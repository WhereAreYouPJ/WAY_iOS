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
    @Published var isAllDay: Bool = true
    @Published var startTime: Date
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
    
    private var rememberedStartTime: Date?
    private var rememberedEndTime: Date?
    
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
        let currentHour = calendar.component(.hour, from: now)
        
        if currentHour >= 23 {
            self.startTime = now
            
            var components = calendar.dateComponents([.year, .month, .day], from: now)
            components.hour = 23
            components.minute = 59
            self.endTime = calendar.date(from: components) ?? now
        } else {
            var startComponents = calendar.dateComponents([.year, .month, .day], from: now)
            startComponents.hour = currentHour + 1
            startComponents.minute = 0
            self.startTime = calendar.date(from: startComponents) ?? now
            
            var endComponents = calendar.dateComponents([.year, .month, .day], from: now)
            endComponents.hour = currentHour + 2
            endComponents.minute = 0
            self.endTime = calendar.date(from: endComponents) ?? now
        }

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
    
    // 기본 시간 설정 로직을 별도 메서드로 분리
    func setTime(for date: Date, hour: Int, minute: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.hour = hour
        components.minute = minute
        return calendar.date(from: components) ?? date
    }
    
    func checkPostAvailable() -> Bool {
        if self.title.isEmpty || (self.place?.location.isEmpty ?? true) { // 일정 제목과 장소 필수 입력
            return false
        }
        if self.endTime < self.startTime { // 일정 종료일이 시작일보다 빠를 수 없음
            return false
        }
        return true
    }
    
    func geocodeSelectedLocation(_ location: Location, completion: @escaping (Location) -> Void) { // 주소를 받아 좌표 리턴
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
                print("지오코딩 성공: ", resultLocation.location, resultLocation.streetName, resultLocation.x, resultLocation.y)
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
            self.favPlaces = locations.sorted { $0.sequence > $1.sequence }
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
        let serverStartTime: String
        let serverEndTime: String
        
        if isAllDay {
            serverStartTime = Calendar.current.startOfDay(for: startTime).formatted(to: .serverSimple)
            serverEndTime = Calendar.current.startOfDay(for: endTime).formatted(to: .serverSimple)
        } else {
            serverStartTime = startTime.formatted(to: .serverSimple)
            serverEndTime = endTime.formatted(to: .serverSimple)
        }
        
        let body = CreateScheduleBody(
            title: title,
            startTime: serverStartTime,
            endTime: serverEndTime,
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
                    print("post 성공! start time: \(serverStartTime), end time: \(serverEndTime)")
                    print("Member Sequence: \(self.memberSeq), Schedule Sequence: \(response.data.scheduleSeq), Chat Root Sequence: \(response.data.chatRootSeq)")
                case .failure(let error):
                    print("postSchedule 요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
