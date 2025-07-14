//
//  HomeDailyScheduleViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 20/1/2025.
//

import Foundation

class BottomSheetViewModel {
    private let getDailyScheduleUseCase: GetDailyScheduleUseCase
    private let getScheduleUseCase: GetScheduleUseCase
    
    let date: Date
    private let dateFormatterS2D: DateFormatter
    private let dateFormatterD2S: DateFormatter
    
    var onDailyScheduleDataFetched: (() -> Void)?
    var displayScheduleData: [Schedule] = []

    var onDailyBottomSheetScheduleFetched: (() -> Void)?
    var displaySheetSchedule: [SheetSchedule] = []
    
    init(
        getDailyScheduleUseCase: GetDailyScheduleUseCase,
        getScheduleUseCase: GetScheduleUseCase,
        date: Date = Date()
    ) {
        self.getDailyScheduleUseCase = getDailyScheduleUseCase
        self.getScheduleUseCase = getScheduleUseCase
        self.date = date
        
        dateFormatterS2D = DateFormatter()
        dateFormatterS2D.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        dateFormatterD2S = DateFormatter()
        dateFormatterD2S.dateFormat = "yyyy-MM-dd"
    }
    
    // MARK: - 바텀시트 UI를 위한 로직 - 정석
    
    func getDailyScheduleForSheet() {
        let date = dateFormatterD2S.string(from: date)
        getDailyScheduleUseCase.execute(date: date) { result in
            switch result {
            case .success(let data):
                self.displaySheetSchedule = data.compactMap { schedule in
                    return SheetSchedule(
                        title: schedule.title,
                        startTime: self.dateFormatterS2D.date(from: schedule.startTime) ?? Date.now,
                        endTime: self.dateFormatterS2D.date(from: schedule.endTime) ?? Date.now,
                        isAllday: schedule.allDay,
                        isGroup: schedule.group,
                        scheduleSeq: schedule.scheduleSeq,
                        location: schedule.location ?? "")
                }
                self.onDailyBottomSheetScheduleFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getSheetSchedule() -> [SheetSchedule] {
        return displaySheetSchedule
    }
    
    // MARK: - 실시간 위치 통신을 위한 데이터를 받아오는 로직 - 주희
    // TODO: 일정 상세 조회API통신 -> 데이터 리턴 받기(success) -> coordinate API통신을 위한 데이터 모델링 -> coordinate API통신 진행하기
    func getScheduleDetail(scheduleSeq: Int, completion: @escaping (Schedule?) -> Void) {
        // 일정 상세 조회 API 호출
        // Schedule 객체 반환 (위치 좌표 포함)
        getScheduleUseCase.execute(scheduleSeq: scheduleSeq) { result in
            switch result {
            case .success(let response):
                guard let startDate = response.startTime.toDate(from: .serverSimple) else {
                    print("Date 변환 실패: \(response.startTime)")
                    return completion(nil)
                }
                guard let endDate = response.endTime.toDate(from: .serverSimple) else {
                    print("Date 변환 실패: \(response.startTime)")
                    return completion(nil)
                }
                
                let schedule = Schedule(
                    scheduleSeq: scheduleSeq,
                    title: response.title,
                    startTime: startDate,
                    endTime: endDate,
                    location: Location(sequence: 0, location: response.location, streetName: response.streetName, x: response.x, y: response.y),
                    color: response.color,
                    invitedMember: response.memberInfos
                        .filter { $0.memberSeq != UserDefaultsManager.shared.getMemberSeq()}
                        .map { friend in
                            Friend(memberSeq: friend.memberSeq, profileImage: "", name: friend.userName, isFavorite: false, memberCode: "")
                        }
                )
                completion(schedule)
            case .failure(let error):
                print("일정 상세 조회 실패: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
    
    func fetchDailySchedule(completion: @escaping (Bool) -> Void) {
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
                                    invitedMember: nil,
                                    isGroup: schedule.group)
                }
                completion(!self.displayScheduleData.isEmpty)
                self.onDailyScheduleDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
                completion(false)
            }
        }
    }
    
    func getSchedules() -> [Schedule] {
        return displayScheduleData
    }
}
