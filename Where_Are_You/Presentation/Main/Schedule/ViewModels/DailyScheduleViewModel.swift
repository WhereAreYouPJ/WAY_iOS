//
//  DailyScheduleViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 07.10.24.
//

import Foundation
import SwiftUICore

class DailyScheduleViewModel: ObservableObject {
    @Published var schedules: [Schedule] = []
    @Published var selectedSchedule: Schedule?
    
    @Published var shouldDismissView = false
    @Published var showingDeleteAlert = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var getDailyScheduleUseCase: GetDailyScheduleUseCase
    private var deleteScheduleUseCase: DeleteScheduleUseCase
    
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    let date: Date
//    private let dateFormatterS2D: DateFormatter
//    private let dateFormatterD2S: DateFormatter
    
    init(
        getDailyScheduleUseCase: GetDailyScheduleUseCase,
        deleteScheduleUseCase: DeleteScheduleUseCase,
        date: Date
    ) {
        self.getDailyScheduleUseCase = getDailyScheduleUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
        self.date = date
        
//        dateFormatterS2D = DateFormatter()
//        dateFormatterS2D.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
//        
//        dateFormatterD2S = DateFormatter()
//        dateFormatterD2S.dateFormat = "yyyy-MM-dd"
    }
    
    func getDailySchedule() {
        getDailyScheduleUseCase.execute(date: date.formatted(to: .yearMonthDateHyphen)) { [weak self] result in
            switch result {
            case .success(let dailySchedules):
                DispatchQueue.main.async {
                    self?.schedules = self?.convertToSchedules(from: dailySchedules) ?? []
                    print("초대된 일정 \(self?.schedules.count ?? 0)개 조회 완료!")
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self?.shouldDismissView = self?.schedules.isEmpty ?? true
                }
            case .failure(let error):
                print("Error getDailySchedule: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSchedule(_ schedule: Schedule, completion: @escaping (Bool) -> Void) {
        self.isLoading = true
        
        let deleteScheduleBody = DeleteScheduleBody(scheduleSeq: schedule.scheduleSeq, memberSeq: memberSeq)
        let isCreator = !(schedule.invitedMember?.contains(where: { $0.memberSeq == memberSeq }) ?? false)
        
        deleteScheduleUseCase.execute(request: deleteScheduleBody, isCreator: isCreator) { result in
            switch result {
            case .success:
                print("일정 삭제 성공!")
            case .failure(let error):
                print("일정 삭제 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    private func convertToSchedules(from schedules: GetScheduleByDateResponse) -> [Schedule] {
        return schedules.compactMap { response -> Schedule? in
            guard let startTime = response.startTime.toDate(from: .serverSimple) else {
                print("startTime 변환 실패: \(response.startTime)")
                return nil
            }
            guard let endTime = response.endTime.toDate(from: .serverSimple) else {
                print("endTime 변환 실패: \(response.endTime)")
                return nil
            }
            
            return Schedule(
                scheduleSeq: response.scheduleSeq,
                title: response.title,
                startTime: startTime,
                endTime: endTime,
                isAllday: response.allDay,
                location: Location(
                    sequence: 0,
                    location: response.location ?? "",
                    streetName: "",
                    x: 0,
                    y: 0
                ),
                color: response.color,
                memo: "",
                invitedMember: nil
            )
        }
    }
    
    func setAlertContent(for schedule: Schedule) -> (String, String) {
        if schedule.invitedMember?.count ?? 0 > 0 {
            return ("그룹 일정 삭제", "그룹 일정을 삭제합니다.\n모든 참여자의 일정에서 삭제되며, 연관된 피드도 함께 삭제됩니다.")
        } else {
            return ("일정 삭제", "일정을 삭제합니다.\n연관된 피드가 있을 경우 함께 삭제됩니다.")
        }
    }
    
    func showDeleteAlert(for schedule: Schedule) {
        selectedSchedule = schedule
        showingDeleteAlert = true
    }
    
    func handleDeleteConfirmation() {
        guard let schedule = selectedSchedule else { return }
        
        deleteSchedule(schedule) { [weak self] _ in
            self?.selectedSchedule = nil
        }
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
        let detailViewModel = ScheduleDetailViewModel(schedule: schedule, getScheduleUseCase: GetScheduleUseCaseImpl(scheduleRepository: ScheduleRepository(scheduleService: ScheduleService())), putScheduleUseCase: PutScheduleUseCaseImpl(scheduleRepository: ScheduleRepository(scheduleService: ScheduleService())))
        
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
