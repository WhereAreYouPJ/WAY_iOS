//
//  DailyScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.10.24.
//

import Foundation
import Moya
import SwiftUICore

class DailyScheduleViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service: ScheduleServiceProtocol
    private let provider = MoyaProvider<ScheduleAPI>()
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    let date: Date
    private let dateFormatterS2D: DateFormatter
    private let dateFormatterD2S: DateFormatter
    
    init(date: Date, service: ScheduleServiceProtocol) {
        self.date = date
        self.service = service
        
        dateFormatterS2D = DateFormatter()
        dateFormatterS2D.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        dateFormatterD2S = DateFormatter()
        dateFormatterD2S.dateFormat = "yyyy-MM-dd"
    }
    
    func getDailySchedule() {
        let date = dateFormatterD2S.string(from: date)
        provider.request(.getDailySchedule(date: date, memberSeq: memberSeq)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<GetScheduleByDateResponse>.self, from: response.data)
                        
                        DispatchQueue.main.async {
                            self.schedules = genericResponse.data.map { schedule in
                                Schedule(scheduleSeq: schedule.scheduleSeq,
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
                            print("일간 일정 로드 성공: \(self.schedules.count)개의 일정을 받았습니다.")
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
    
    func deleteSchedule(_ schedule: Schedule, completion: @escaping (Bool) -> Void) {
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
                    self?.getDailySchedule()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let isEmpty = self?.schedules.isEmpty {
                            completion(isEmpty)
                        }
                    }
                case .failure(let error):
                    print("Failed to delete schedule: \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }
    
    func isEditableSchedule(_ schedule: Schedule) -> Bool {
        return false
    }
    
    func isOneDaySchedule(_ schedule: Schedule) -> Bool {
        let startDate = dateFormatterD2S.string(from: schedule.startTime)
        let endDate = dateFormatterD2S.string(from: schedule.endTime)
        return startDate == endDate
    }
    
    func getScheduleDate(_ schedule: Schedule) -> String? {
        let startDate = formatDate(schedule.startTime)
        let endDate = formatDate(schedule.endTime)
        let startTime = formatTime(schedule.startTime)
        let endTime = formatTime(schedule.endTime)
        
        if !(schedule.isAllday ?? true) {
            if startDate == endDate { /// 하루 일정
                if startTime == endTime {
                    return startTime
                } else {
                    return "\(startTime) - \(endTime)"
                }
            } else { /// 이틀 이상 일정
                return "\(startDate) \(startTime) - \(endDate) \(endTime)"
            }
        } else { /// 하루종일 일정
            return nil
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        
        return formatter.string(from: date)
    }
    
    func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let minute = calendar.component(.minute, from: date)
        
        if minute == 0 {
            formatter.dateFormat = "a h시"
        } else {
            formatter.dateFormat = "a h시 m분"
        }
        
        return formatter.string(from: date)
    }
    
    func scheduleColor(for color: String) -> Color {
        switch color {
        case "red": return Color.colorRed
        case "yellow": return Color.colorYellow
        case "green": return Color.colorGreen
        case "blue": return Color.colorBlue
        case "violet": return Color.colorViolet
        case "pink": return Color.colorPink
        default: return Color.colorRed
        }
    }
}

extension DailyScheduleViewModel {
    func createScheduleDetailViewModel(for schedule: Schedule) -> ScheduleDetailViewModel {
        let detailViewModel = ScheduleDetailViewModel(schedule: schedule)
        
        // isSuccess 상태 변화 관찰
        detailViewModel.$isSuccess
            .sink { [weak self] success in
                if success {
                    self?.getDailySchedule()
                }
            }
            .store(in: &detailViewModel.cancellables)
            
        return detailViewModel
    }
}
