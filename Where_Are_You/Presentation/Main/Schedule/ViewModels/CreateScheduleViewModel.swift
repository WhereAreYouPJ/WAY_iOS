//
//  CreateScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI

class CreateScheduleViewModel: ObservableObject {
    enum OutputEvent {
        case success, error
    }
    
    @Published var schedule: Schedule? = nil
    @Published var outputEvent: OutputEvent? = nil
    @Published var responseCreation: String? = nil
    
    func postSchedule() {
        
    }
}
