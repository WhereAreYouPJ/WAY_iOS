//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI
import Combine

final class CreateScheduleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var isAllDay: Bool = true {
        didSet {
            if isAllDay { // 하루종일이 켜지면 종료일을 시작일과 동일하게 설정
                endTime = Calendar.current.startOfDay(for: startTime)
            }
        }
    }
    @Published var startTime: Date {
        didSet {
            if isAllDay { // 하루종일일 때 시작일이 변경되면 종료일도 함께 변경
                endTime = Calendar.current.startOfDay(for: startTime)
            }
        }
    }
    @Published var endTime: Date
    @Published var selectedFriends: [Friend] = []
    @Published var place: Location?
    @Published var favPlaces: [Location] = []
    @Published var color: String = "red"
    @Published var memo: String = ""
    @Published var isEditingMemo = false
    @Published var isSuccess = false
    
    private let postScheduleUseCase: PostScheduleUseCase
    private let getFavoriteLocationUseCase: GetLocationUseCase
    private let geocodeLocationUseCase: GeocodeLocationUseCase
    private var cancellables = Set<AnyCancellable>()
    
    let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    init(
        schedule: Schedule? = nil,
        postScheduleUseCase: PostScheduleUseCase,
        getFavoriteLocationUseCase: GetLocationUseCase,
        geocodeLocationUseCase: GeocodeLocationUseCase
    ) {
        self.postScheduleUseCase = postScheduleUseCase
        self.getFavoriteLocationUseCase = getFavoriteLocationUseCase
        self.geocodeLocationUseCase = geocodeLocationUseCase
        
        if let schedule = schedule {
            self.title = schedule.title
            self.isAllDay = schedule.isAllday ?? false
            self.startTime = schedule.startTime
            self.endTime = schedule.endTime
            self.place = schedule.location ?? Location(sequence: 0, location: "", streetName: "", x: 0, y: 0)
            self.selectedFriends = schedule.invitedMember ?? []
            self.color = schedule.color
            self.memo = schedule.memo ?? ""
        }
        
        let calendar = Calendar.current
        let now = Date()
        
        // 시각 초기값: 현재 시간 + 1 hour, 00 minute
        var components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        components.hour = (components.hour ?? 0) + 1
        components.minute = 0
        components.second = 0
        
        let startOfNextHour = calendar.date(from: components) ?? now
        let endOfNextHour = calendar.date(byAdding: .hour, value: 1, to: startOfNextHour) ?? now

        self.startTime = startOfNextHour
        self.endTime = endOfNextHour // TODO: 23시 이후에 하루종일 토글 on 할 경우 시작일과 종료날이 달라지는 부분 수정 필요
        
        if let schedule = schedule { // 기존 일정이 있으면 값 설정
            self.title = schedule.title
            self.isAllDay = schedule.isAllday ?? false
            self.startTime = schedule.startTime
            self.endTime = schedule.endTime
            self.color = schedule.color
            self.memo = schedule.memo ?? ""
            self.selectedFriends = schedule.invitedMember ?? []
            
            if let scheduleLocation = schedule.location { // 위치 정보가 있으면 시퀀스 유지하며 설정
                // 즐겨찾기 목록에서 시퀀스 확인
                if let favoriteLocation = LocationManager.shared.findLocationByAddress(
                    location: scheduleLocation.location,
                    streetName: scheduleLocation.streetName
                ) {
                    self.place = Location(
                        locationSeq: favoriteLocation.locationSeq,
                        sequence: favoriteLocation.sequence,
                        location: scheduleLocation.location,
                        streetName: scheduleLocation.streetName,
                        x: scheduleLocation.x,
                        y: scheduleLocation.y
                    )
                } else {
                    self.place = scheduleLocation
                }
            }
        }
        
        LocationManager.shared.$favoriteLocations // LocationManager의 즐겨찾기 목록 변경 구독
            .sink { [weak self] locations in
                self?.updateFavoritePlaces(locations)
                self?.syncPlaceWithFavorites()
            }
            .store(in: &cancellables)
    }
    
    func geocodeSelectedLocation(_ location: Location, completion: @escaping (Location) -> Void) {
        let locationWithSequence = LocationManager.shared.applyFavoriteSequence(to: location) // 즐겨찾기된 위치라면 시퀀스 유지
        
        geocodeLocationUseCase.execute(location: locationWithSequence) { result in
            switch result {
            case .success(let geocodedLocation):
                let resultLocation = Location(
                    locationSeq: locationWithSequence.locationSeq,
                    sequence: locationWithSequence.sequence,
                    location: geocodedLocation.location,
                    streetName: geocodedLocation.streetName,
                    x: geocodedLocation.x,
                    y: geocodedLocation.y
                )
                completion(resultLocation)
            case .failure(let error):
                print("지오코딩 실패: \(error.localizedDescription)")
                completion(locationWithSequence)
            }
        }
    }
    
    func getFavoriteLocation() { // LocationManager를 통해 즐겨찾기 새로고침
        LocationManager.shared.loadFavoriteLocations()
    }
    
    private func updateFavoritePlaces(_ locations: [Location]) {
        DispatchQueue.main.async {
            self.favPlaces = locations
            print("즐겨찾기 위치 \(locations.count)개 업데이트됨")
        }
    }

    private func syncPlaceWithFavorites() { // 현재 선택된 위치와 즐겨찾기 목록 동기화
        guard let currentPlace = place else { return }
        
        // 현재 선택된 위치가 즐겨찾기 목록에 있는지 확인
        if let favoriteMatch = LocationManager.shared.findLocationByAddress(
            location: currentPlace.location,
            streetName: currentPlace.streetName
        ) {
            if currentPlace.sequence != favoriteMatch.sequence ||
                currentPlace.locationSeq != favoriteMatch.locationSeq { // 시퀀스가 다르면 업데이트
                DispatchQueue.main.async {
                    self.place = Location(
                        locationSeq: favoriteMatch.locationSeq,
                        sequence: favoriteMatch.sequence,
                        location: currentPlace.location,
                        streetName: currentPlace.streetName,
                        x: currentPlace.x,
                        y: currentPlace.y
                    )
                    print("선택된 위치 시퀀스 업데이트: sequence=\(favoriteMatch.sequence), locationSeq=\(String(describing: favoriteMatch.locationSeq))")
                }
            }
        } else if currentPlace.sequence > 0 || currentPlace.locationSeq != nil {
            DispatchQueue.main.async { // 즐겨찾기에 없는데 시퀀스가 있으면 (즐겨찾기 삭제된 경우) 시퀀스 리셋
                self.place = Location(
                    locationSeq: nil,
                    sequence: 0,
                    location: currentPlace.location,
                    streetName: currentPlace.streetName,
                    x: currentPlace.x,
                    y: currentPlace.y
                )
                print("즐겨찾기에서 제거된 위치 시퀀스 리셋")
            }
        }
    }
    
    func postSchedule() {
        let invitedMemberSeqs = selectedFriends.map { $0.memberSeq }
        let body = CreateScheduleBody(
            title: title,
            startTime: startTime.formatted(to: .serverSimple),
            endTime: endTime.formatted(to: .serverSimple),
            location: place?.location,
            streetName: place?.streetName,
            x: place?.x,
            y: place?.y,
            color: color,
            memo: memo,
            allDay: isAllDay,
            invitedMemberSeqs: invitedMemberSeqs,
            createMemberSeq: memberSeq
        )
        
        postScheduleUseCase.execute(request: body) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.isSuccess = true
                    print("post 성공! start time: \(self.startTime.formatted(to: .serverSimple)), end time: \(self.startTime.formatted(to: .serverSimple))")
                    print("Member Sequence: \(self.memberSeq), Schedule Sequence: \(response.data.scheduleSeq), Chat Root Sequence: \(response.data.chatRootSeq)")
                case .failure(let error):
                    print("postSchedule 요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
