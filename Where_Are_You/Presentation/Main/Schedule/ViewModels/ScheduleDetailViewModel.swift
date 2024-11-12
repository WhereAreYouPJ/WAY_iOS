//
//  ScheduleDetailViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 05.11.24.
//

import Foundation
import Moya

class ScheduleDetailViewModel: ObservableObject {
    @Published var schedule: Schedule
    @Published var createViewModel: CreateScheduleViewModel
    @Published var isSuccess = false
    
    private let service = ScheduleService()
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    private var isGroupSchedule: Bool {
        return !(schedule.invitedMember?.isEmpty ?? true)
    }
    
    private var isScheduleCreator: Bool {
        return schedule.invitedMember?.contains { $0.memberSeq == memberSeq } ?? false
    }
    
    var isEditable: Bool {
        let oneHourBefore = Date().addingTimeInterval(3600)
        if (schedule.startTime > oneHourBefore) && (!isGroupSchedule || isScheduleCreator) {
            return true
        }
        return false
    }
    
    init(schedule: Schedule) {
        self.schedule = schedule
        self.createViewModel = CreateScheduleViewModel(schedule: schedule)
    }
    
    func updateSchedule() {
    }
}
