//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI

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
    @Published var place: Location = Location(sequence: 0, location: "", streetName: "", x: 0, y: 0) // TODO: 서버 nullable 값 수정 필요?
    @Published var favPlaces: [Location] = []
    @Published var color: String = "red"
    @Published var memo: String = ""
    @Published var isSuccess = false
    
    private let postScheduleUseCase: PostScheduleUseCase
    private let getFavoriteLocationUseCase: GetLocationUseCase
    private let geocodeLocationUseCase: GeocodeLocationUseCase
    
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
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        let startOfHour = calendar.date(from: components)!
        let endOfHour = calendar.date(byAdding: .hour, value: 1, to: startOfHour)!
        
        self.startTime = startOfHour
        self.endTime = endOfHour // TODO: 23시 이후에 하루종일 토글 on 할 경우 시작일과 종료날이 달라지는 부분 수정 필요
    }
    
    func geocodeSelectedLocation(_ location: Location, completion: @escaping (Location) -> Void) {
        geocodeLocationUseCase.execute(location: location) { result in
            switch result {
            case .success(let geocodedLocation):
                completion(geocodedLocation)
            case .failure(let error):
                print("지오코딩 실패: \(error.localizedDescription)")
                completion(location)
            }
        }
    }
    
    func getFavoriteLocation() {
        getFavoriteLocationUseCase.execute(memberSeq: memberSeq, completion: { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    
                    self.favPlaces = response.map { location in
                        Location(
                            sequence: location.locationSeq,
                            location: location.location,
                            streetName: location.streetName,
                            x: 0,
                            y: 0
                        )
                    }
                    print("즐겨찾기 위치 로드 성공: \(self.favPlaces.count)개의 위치를 받았습니다.")
                case .failure(let error):
                    print("즐겨찾기 위치 로드 실패: \(error.localizedDescription)")
                }
            }
        })
    }
    
    func postSchedule() {
        let invitedMemberSeqs = selectedFriends.map { $0.memberSeq }
        let body = CreateScheduleBody(title: title, startTime: startTime.formatted(to: .serverSimple), endTime: endTime.formatted(to: .serverSimple), location: place.location, streetName: place.streetName, x: place.x, y: place.y, color: color, memo: memo, allDay: isAllDay, invitedMemberSeqs: invitedMemberSeqs, createMemberSeq: memberSeq)
        
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
