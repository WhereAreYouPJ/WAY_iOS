//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI
import Moya

class CreateScheduleViewModel: ObservableObject {
    private let provider = MoyaProvider<ScheduleAPI>()
    
    @Published var isSuccess = false
    @Published var errorMessage = ""
    
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
