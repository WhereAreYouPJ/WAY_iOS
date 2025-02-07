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
    
    func setDeleteAlertContent(for schedule: Schedule) -> (String, String) {
        print("invitedMember 수: \(schedule.invitedMember?.count ?? 0)")
        if schedule.isGroup == true {
            return ("그룹 일정 삭제", "그룹 일정을 삭제합니다.\n모든 참여자의 일정에서 삭제되며, 연관된 피드도 함께 삭제됩니다.")
        } else {
            return ("일정 삭제", "일정을 삭제합니다.\n연관된 피드가 있을 경우 함께 삭제됩니다.")
        }
    }
    
    func hasSchedules(for date: Date) -> Bool {
        let dayStart = Calendar.current.startOfDay(for: date)
        return monthlySchedules.contains { schedule in
            let scheduleStartDate = Calendar.current.startOfDay(for: schedule.startTime)
            let scheduleEndDate = Calendar.current.startOfDay(for: schedule.endTime)
            return (scheduleStartDate...scheduleEndDate).contains(dayStart)
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
                                Schedule(
                                    scheduleSeq: schedule.scheduleSeq,
                                    title: schedule.title,
                                    startTime: self.dateFormatterS2D.date(from: schedule.startTime) ?? Date.now,
                                    endTime: self.dateFormatterS2D.date(from: schedule.endTime) ?? Date.now,
                                    isAllday: schedule.allDay,
                                    location: Location(sequence: 0, location: schedule.location ?? "", streetName: schedule.streetName ?? "", x: schedule.x ?? 0, y: schedule.y ?? 0),
                                    color: schedule.color,
                                    memo: schedule.memo,
                                    invitedMember: nil)
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
                print("getMonthlySchedule 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSchedule(_ schedule: Schedule, completion: @escaping () -> Void) {
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
                    self?.getMonthlySchedule()  // 삭제 성공 후 바로 데이터 갱신
                    completion()  // 완료 콜백 호출
                case .failure(let error):
                    print("Failed to delete schedule: \(error.localizedDescription)")
                }
            }
        }
    }
}
