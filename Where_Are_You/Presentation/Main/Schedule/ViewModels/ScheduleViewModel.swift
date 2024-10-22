//
//  CalendarViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 31.08.24.
//

import Foundation
import Moya

class ScheduleViewModel: ObservableObject {
    @Published var month: Date = Date()
    @Published var clickedCurrentMonthDates: Date?
    @Published var monthlySchedules: [Schedule] = []
    @Published var dailySchedules: [Schedule] = []
    @Published var isLoading = false
    
    let provider = MoyaProvider<ScheduleAPI>()
    private let service: ScheduleServiceProtocol
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    private let dateFormatterS2D: DateFormatter
    private let dateFormatterD2S: DateFormatter
    
    init(service: ScheduleServiceProtocol) {
        self.service = service
        
        dateFormatterS2D = DateFormatter()
        dateFormatterS2D.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        dateFormatterD2S = DateFormatter()
        dateFormatterD2S.dateFormat = "yyyy-MM"
    }
    
    func changeMonth(by value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            month = newMonth
        }
    }
    
    func getMonthlySchedule() {
        let yearMonth = dateFormatterD2S.string(from: month)
        provider.request(.getMonthlySchedule(yearMonth: yearMonth, memberSeq: memberSeq)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<GetScheduleByMonthResponse>.self, from: response.data)
                        
                        DispatchQueue.main.async {
                            self.monthlySchedules = genericResponse.data.map { schedule in
                                Schedule(scheduleSeq: schedule.scheduleSeq, title: schedule.title, startTime: self.dateFormatterS2D.date(from: schedule.startTime) ?? Date.now, endTime: self.dateFormatterS2D.date(from: schedule.endTime) ?? Date.now, isAllday: schedule.allDay, location: Location(sequence: 0, location: schedule.location ?? "", streetName: schedule.streetName ?? "", x: schedule.x ?? 0, y: schedule.y ?? 0), color: schedule.color, memo: schedule.memo, invitedMember: nil)
                            }
                            print("월간 일정 로드 성공: \(self.monthlySchedules.count)개의 일정을 받았습니다.")
                        }
                    } catch {
                        print("JSON 디코딩 실패: \(error.localizedDescription)")
                    }
                } else {
                    print("서버 오류: \(response.statusCode)")
                    if let json = try? response.mapJSON() as? [String: Any],
                       let detail = json["detail"] as? String {
                        print("상세 메시지: \(detail)")
                    }
                }
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSchedule(_ schedule: Schedule) {
        isLoading = true
        
        let deleteRequest = DeleteScheduleBody(scheduleSeq: schedule.scheduleSeq, memberSeq: memberSeq)
        let isCreator = !(schedule.invitedMember?.contains(where: { $0.memberSeq == memberSeq }) ?? false)
        
        let deleteMethod = isCreator ? service.deleteScheduleByCreator : service.deleteScheduleByInvitee
        
        deleteMethod(deleteRequest) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success:
                    print("Schedule successfully deleted")
                case .failure(let error):
                    print("Failed to delete schedule: \(error.localizedDescription)")
                }
            }
        }
    }
}
