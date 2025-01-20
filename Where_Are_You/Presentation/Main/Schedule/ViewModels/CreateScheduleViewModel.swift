//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI
import Moya
import CoreLocation

final class CreateScheduleViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var isAllDay: Bool = true {
        didSet {
            if isAllDay {
                // 하루종일이 켜지면 종료일을 시작일과 동일하게 설정
                endTime = Calendar.current.startOfDay(for: startTime)
            }
        }
    }
    @Published var startTime: Date {
        didSet {
            if isAllDay {
                // 하루종일일 때 시작일이 변경되면 종료일도 함께 변경
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
    
    private let locationService: LocationServiceProtocol
    private let scheduleService: ScheduleServiceProtocol
    let provider = MoyaProvider<LocationAPI>()
    let geocoder = CLGeocoder()
    let dateFormatter: DateFormatter
    let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    init(schedule: Schedule? = nil,
         locationService: LocationServiceProtocol = LocationService(),
         scheduleService: ScheduleServiceProtocol = ScheduleService()) {
        self.locationService = locationService
        self.scheduleService = scheduleService
        
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
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    
    func geocodeSelectedLocation(_ location: Location, completion: @escaping (Location) -> Void) {
        geocoder.geocodeAddressString(location.streetName) { placemarks, error in
            if let error = error {
                print("지오코딩 실패: \(error.localizedDescription)")
                completion(location)
            } else if let placemark = placemarks?.first, let coordinate = placemark.location?.coordinate {
                let geocodedLocation = Location(
                    sequence: location.sequence,
                    location: location.location,
                    streetName: location.streetName,
                    x: coordinate.longitude,
                    y: coordinate.latitude
                )
                completion(geocodedLocation)
            } else {
                completion(location)
            }
        }
    }
    
    func getFavoriteLocation() {
        locationService.getLocation(memberSeq: memberSeq) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.favPlaces = response.data.map { location in
                        Location(
                            sequence: location.locationSeq,
                            location: location.location,
                            streetName: location.streetName,
                            x: 0,
                            y: 0
                        )
                    }
                    print("즐겨찾기 위치 로드 성공: \(self.favPlaces.count)개의 위치를 받았습니다.")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("즐겨찾기 위치 로드 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func postSchedule() {
        let provider = MoyaProvider<ScheduleAPI>()
        let invitedMemberSeqs = selectedFriends.map { $0.memberSeq }
        let body = CreateScheduleBody(title: title, startTime: dateFormatter.string(from: startTime), endTime: dateFormatter.string(from: endTime), location: place.location, streetName: place.streetName, x: place.x, y: place.y, color: color, memo: memo, allDay: isAllDay, invitedMemberSeqs: invitedMemberSeqs, createMemberSeq: memberSeq)
        
        scheduleService.postSchedule(request: body) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.isSuccess = true
                    print("post 성공! start time: \(self.startTime.toString()), end time: \(self.endTime.toString())")
                    print("Member Sequence: \(self.memberSeq), Schedule Sequence: \(response.data.scheduleSeq), Chat Root Sequence: \(response.data.chatRootSeq)")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    print("요청 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}

func handleErrorResponse(_ result: Response, endpoint: String, params: [String: Any]? = nil) {
    DispatchQueue.main.async {
        var errorMessage = "\(endpoint) 오류:"
        
        do {
            let errorResponse = try result.map(ErrorResponse.self)
            errorMessage += "\n상태 코드: \(errorResponse.status)"
            errorMessage += "\n메시지: \(errorResponse.message)"
            errorMessage += "\n에러 코드: \(errorResponse.code)"
        } catch {
            errorMessage += "\n상태 코드: \(result.statusCode)"
            errorMessage += "\n응답 파싱 실패: \(error)"
        }
        
        if let params = params {
            errorMessage += "\n매개변수: \(params)"
        }
        
        print(errorMessage)
    }
}
