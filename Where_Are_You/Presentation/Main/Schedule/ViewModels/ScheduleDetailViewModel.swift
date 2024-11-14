//
//  ScheduleDetailViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 05.11.24.
//

import Foundation
import Moya
import Combine

class ScheduleDetailViewModel: ObservableObject {
    @Published var schedule: Schedule
    @Published var createViewModel: CreateScheduleViewModel
    @Published var isSuccess = false
    
    private let service = ScheduleService()
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    let provider = MoyaProvider<ScheduleAPI>()
    var cancellables = Set<AnyCancellable>() // Combine 구독 저장용
    
    private var isGroupSchedule: Bool {
        return !(schedule.invitedMember?.isEmpty ?? true)
    }
    
    private var isScheduleCreator: Bool {
        return !(schedule.invitedMember?.contains { $0.memberSeq == memberSeq } ?? false)
    }
    
    var isEditable: Bool {
        let oneHourBefore = Date().addingTimeInterval(3600)
        if (schedule.startTime > oneHourBefore) && (!isGroupSchedule || isScheduleCreator) {
            return true
        }
        return false
    }
    
    init(schedule: Schedule) {
        print("ScheduleDetailViewModel init with schedule: \(schedule.title)")
        self.schedule = schedule
        self.createViewModel = CreateScheduleViewModel(schedule: schedule)
    }
    
    func updateSchedule() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let endTime = schedule.isAllday ?? false ? schedule.startTime : schedule.endTime
        
        let updateRequest = PutScheduleBody(
            scheduleSeq: schedule.scheduleSeq,
            title: schedule.title,
            startTime: dateFormatter.string(from: schedule.startTime),
            endTime: dateFormatter.string(from: endTime),
            location: schedule.location?.location ?? "",
            streetName: schedule.location?.streetName ?? "",
            x: schedule.location?.x ?? 0,
            y: schedule.location?.y ?? 0,
            color: schedule.color,
            memo: schedule.memo ?? "",
            allDay: schedule.isAllday ?? false,
            invitedMemberSeqs: schedule.invitedMember?.map { $0.memberSeq } ?? [],
            createMemberSeq: memberSeq
        )
        
        print(updateRequest)
        
        service.putSchedule(request: updateRequest) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.isSuccess = true
                    print("일정 수정 성공! scheduleSeq: \(response.data.scheduleSeq)")
                case .failure(let error):
                    self.isSuccess = false
                    print("일정 수정 실패: \(error.localizedDescription)")
                    // TODO: 실패 시 사용자에게 알림을 보여주는 로직 추가 필요
                }
            }
        }
    }
}
