//
//  HomeDailyScheduleViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 20/1/2025.
//

import Foundation

class BottomSheetViewModel {
    private let getDailyScheduleUseCase: GetDailyScheduleUseCase
    let date: Date
    private let dateFormatterS2D: DateFormatter
    private let dateFormatterD2S: DateFormatter
    
    var onDailyScheduleDataFetched: (() -> Void)?

    var displayScheduleData: [Schedule] = []
    
    init(getDailyScheduleUseCase: GetDailyScheduleUseCase, date: Date = Date()) {
        self.getDailyScheduleUseCase = getDailyScheduleUseCase
        self.date = date
        
        dateFormatterS2D = DateFormatter()
        dateFormatterS2D.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        dateFormatterD2S = DateFormatter()
        dateFormatterD2S.dateFormat = "yyyy-MM-dd"
    }
    
    func fetchDailySchedule() {
        let date = dateFormatterD2S.string(from: date)
        getDailyScheduleUseCase.execute(date: date) { result in
            switch result {
            case .success(let data):
                
                self.displayScheduleData = data.compactMap { schedule in
                    return Schedule(scheduleSeq: schedule.scheduleSeq,
                                    title: schedule.title,
                                    startTime: self.dateFormatterS2D.date(from: schedule.startTime) ?? Date.now,
                                    endTime: self.dateFormatterS2D.date(from: schedule.endTime) ?? Date.now,
                                    isAllday: schedule.allDay,
                                    location: Location(sequence: 0,
                                                       location: schedule.location ?? "",
                                                       streetName: "",
                                                       x: 0,
                                                       y: 0),
                                    color: schedule.color,
                                    memo: "",
                                    invitedMember: nil)
                }
                self.onDailyScheduleDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSchedules() -> [Schedule] {
        return displayScheduleData
    }
}
