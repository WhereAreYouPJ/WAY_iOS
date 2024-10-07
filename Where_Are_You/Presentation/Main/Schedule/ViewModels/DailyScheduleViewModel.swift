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
    
    private let provider = MoyaProvider<ScheduleAPI>()
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    let date: Date
    private let dateFormatterS2D: DateFormatter
    private let dateFormatterD2S: DateFormatter
    
    init(date: Date) {
        self.date = date
        
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
    
    func deleteSchedule(_ schedule: Schedule) {
        schedules.removeAll { $0.scheduleSeq == schedule.scheduleSeq }
        // TODO: Implement API call to delete schedule from backend
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 a h시"
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
