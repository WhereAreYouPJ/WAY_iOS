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
        /// Dummy Data
//        monthlySchedules = [
//            Schedule(
//                scheduleSeq: 1,
//                title: "3일 연속 일정",
//                startTime: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
//                endTime: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
//                isAllday: true,
//                location: Location(sequence: 1, location: "망원한강공원", streetName: "", x: 0, y: 0),
//                color: "red",
//                memo: "",
//                invitedMember: [Friend(memberSeq: 1, profileImage: "", name: "")]
//            ),
//            Schedule(
//                scheduleSeq: 2,
//                title: "오늘 하루 종일",
//                startTime: Calendar.current.startOfDay(for: Date()),
//                endTime: Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: Date()))!,
//                isAllday: true,
//                location: nil,
//                color: "blue",
//                memo: "",
//                invitedMember: []
//            ),
//            Schedule(
//                scheduleSeq: 3,
//                title: "오후 쇼핑",
//                startTime: Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: Date())!,
//                endTime: Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date())!,
//                isAllday: false,
//                location: Location(sequence: 1, location: "성수역", streetName: "", x: 0, y: 0),
//                color: "yellow",
//                memo: "",
//                invitedMember: []
//            ),
//            Schedule(
//                scheduleSeq: 4,
//                title: "새벽 러닝",
//                startTime: Calendar.current.date(bySettingHour: 5, minute: 30, second: 0, of: Date())!,
//                endTime: Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date())!,
//                isAllday: false,
//                location: nil,
//                color: "violet",
//                memo: "",
//                invitedMember: []
//            ),
//            Schedule(
//                scheduleSeq: 5,
//                title: "자정 넘어가는 영화",
//                startTime: Calendar.current.date(bySettingHour: 22, minute: 10, second: 0, of: Date())!,
//                endTime: Calendar.current.date(byAdding: .hour, value: 3, to: Calendar.current.date(bySettingHour: 22, minute: 10, second: 0, of: Date())!)!,
//                isAllday: false,
//                location: Location(sequence: 2, location: "강남역 CGV", streetName: "", x: 0, y: 0),
//                color: "green",
//                memo: "",
//                invitedMember: []
//            ),
//            Schedule(
//                scheduleSeq: 6,
//                title: "점심 약속",
//                startTime: Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!,
//                endTime: Calendar.current.date(bySettingHour: 13, minute: 0, second: 0, of: Date())!,
//                isAllday: false,
//                location: Location(sequence: 3, location: "강남역 레스토랑", streetName: "", x: 0, y: 0),
//                color: "pink",
//                memo: "",
//                invitedMember: [Friend(memberSeq: 2, profileImage: "", name: "김철수")]
//            )
//        ]
        
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
