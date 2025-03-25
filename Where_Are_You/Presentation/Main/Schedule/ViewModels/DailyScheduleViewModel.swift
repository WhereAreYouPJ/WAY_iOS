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
    
    @Published var showingDeleteAlert = false
    @Published var errorMessage: String?
    
    private var getDailyScheduleUseCase: GetDailyScheduleUseCase
    private var deleteScheduleUseCase: DeleteScheduleUseCase
    
    private var memberSeq = UserDefaultsManager.shared.getMemberSeq()
    let date: Date
    
    init(
        getDailyScheduleUseCase: GetDailyScheduleUseCase,
        deleteScheduleUseCase: DeleteScheduleUseCase,
        date: Date
    ) {
        self.getDailyScheduleUseCase = getDailyScheduleUseCase
        self.deleteScheduleUseCase = deleteScheduleUseCase
        self.date = date
    }
    
    func getDailySchedule() {
        getDailyScheduleUseCase.execute(date: date.formatted(to: .yearMonthDateHyphen)) { [weak self] result in
            switch result {
            case .success(let dailySchedules):
                DispatchQueue.main.async {
                    self?.schedules = self?.convertToSchedules(from: dailySchedules) ?? []
                    print("초대된 일정 \(self?.schedules.count ?? 0)개 조회 완료!")
                }
            case .failure(let error):
                print("Error getDailySchedule: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteSchedule(completion: @escaping (Bool) -> Void) {
        guard let schedule = selectedSchedule else {
            completion(false)
            return
        }
        
        let deleteScheduleBody = DeleteScheduleBody(scheduleSeq: schedule.scheduleSeq, memberSeq: memberSeq)
        let isCreator = !(schedule.invitedMember?.contains(where: { $0.memberSeq == memberSeq }) ?? false)
        
        deleteScheduleUseCase.execute(request: deleteScheduleBody, isCreator: isCreator) { result in
            switch result {
            case .success:
                self.getDailySchedule()
                completion(true)
            case .failure(let error):
                print("일정 삭제 실패 - \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func convertToSchedules(from schedules: GetScheduleByDateResponse) -> [Schedule] {
        return schedules.compactMap { response -> Schedule? in
            guard let startTime = response.startTime.toDate(from: .serverSimple),
                  let endTime = response.endTime.toDate(from: .serverSimple) else {
                print("startTime or endTime 변환 실패: \(response.startTime)")
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
                invitedMember: nil,
                isGroup: response.group
            )
        }
    }
    
    func showDeleteAlert(for schedule: Schedule) {
        selectedSchedule = schedule
        showingDeleteAlert = true
    }
    
    func getDeleteAlertContent(for schedule: Schedule) -> (String, String) {
        print("invitedMember 수: \(schedule.invitedMember?.count ?? 0)")
        if schedule.isGroup == true {
            return ("그룹 일정 삭제", "그룹 일정을 삭제합니다.\n모든 참여자의 일정에서 삭제되며, 연관된 피드도 함께 삭제됩니다.")
        } else {
            return ("일정 삭제", "일정을 삭제합니다.\n연관된 피드가 있을 경우 함께 삭제됩니다.")
        }
    }
    
    func getScheduleDate(_ schedule: Schedule) -> String? {
        // 하루종일 일정인 경우 시간 표시하지 않음
        if schedule.isAllday ?? true {
            return nil
        }
        
        let startDate = schedule.startTime.formatted(to: .monthDaySimple)
        let endDate = schedule.endTime.formatted(to: .monthDaySimple)
        
        let startTime = schedule.startTime.formatted(to: schedule.startTime.determineTimeFormat())
        let endTime = schedule.endTime.formatted(to: schedule.endTime.determineTimeFormat())
        
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
