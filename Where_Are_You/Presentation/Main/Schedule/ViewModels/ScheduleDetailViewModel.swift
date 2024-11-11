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
    
    init(schedule: Schedule) {
        self.schedule = schedule
        self.createViewModel = CreateScheduleViewModel(schedule: schedule)
    }
    
    func updateSchedule() {
    }
}
