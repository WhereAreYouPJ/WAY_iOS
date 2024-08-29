//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI
import Moya

class CreateScheduleViewModel: ObservableObject {
    @Published var schedule = Schedule()
    @Published var isAllDay = true
    @Published var startTime = Date()
    @Published var endTime = Date()
    @Published var selectedFriends: [Friend] = []
    
    private let dateFormatter: DateFormatter
    private let provider = MoyaProvider<ScheduleAPI>()
    
    @Published var isSuccess = false
    @Published var errorMessage = ""
    
    init() {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day, .hour], from: now)
        let startOfHour = calendar.date(from: components)!
        
        self.startTime = startOfHour
        self.endTime = calendar.date(byAdding: .hour, value: 1, to: startOfHour)!
        
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd a hh:mm"
    }
    
    func updateSelectedFriends(_ friends: [Friend]) {
        selectedFriends = friends
    }
    
    func postSchedule(schedule: Schedule) {
        provider.request(.postSchedule(request: CreateScheduleBody.init(title: schedule.title, startTime: schedule.startTime, endTime: schedule.endTime, location: schedule.location, streetName: schedule.streetName, x: schedule.x, y: schedule.y, color: schedule.color, memo: schedule.memo, invitedMemberSeqs: schedule.invitedMemberSeqs, createMemberSeq: schedule.createMemberSeq))) { response in
            switch response {
            case .success(let result):
                if result.statusCode == 200 {
                    DispatchQueue.main.async {
                        self.isSuccess = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "서버 오류: \(result.statusCode)"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.errorMessage = "요청 실패: \(error.localizedDescription)"
                }
            }
        }
    }
}
