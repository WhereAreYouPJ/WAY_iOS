//
//  AddFeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/8/2024.
//

import Foundation

//1. 서버에서 보내주는 데이터 안의 content 값들을 분석해서 피드에 뜨게 해야한다.
//2. content의 시간을 확인하고 같은것들끼리 묶어서 테이블뷰 섹션에 일별로 분리해서 만들어야 함
//3. 오는 데이터는 오래된 일정 순서대로 날아오니 순서대로 확인하면 될듯.
//4. 피드를 생성했는지 안했는지를 확인할수 있게 추가 데이터를 서버에서 보내주게 하면 될듯하다.
//5. 일정을 함께하는 친구가 있는 경우 어떻게 되는지 확인하기
protocol AddFeedViewModelDelegate: AnyObject {
    func didUpdateSchedules()
}

class AddFeedViewModel {
    private let getScheduleListUseCase: GetScheduleListUseCase
    
    private var schedules: [ScheduleList] = []
    private var page: Int32 = 0
    private var isLoading = false
    
    private var groupedSchedules: [String: [ScheduleList]] = [:]
    var selectedScheduleSeq: Int?
    
    var onSchedulesUpadated: (() -> Void)?
    
    weak var delegate: AddFeedViewModelDelegate?
    // MARK: - Lifecycle
    init(getScheduleListUseCase: GetScheduleListUseCase) {
        self.getScheduleListUseCase = getScheduleListUseCase
    }
    
    // MARK: - Helpers

    func fetchSchedules() {
        guard !isLoading else { return }
        isLoading = true
        
        getScheduleListUseCase.execute(page: page) { result in
            switch result {
            case .success(let newSchedules):
//                self.schedules.append(contentsOf: newSchedules)
                self.page += 1
                self.onSchedulesUpadated?()
                // 여기에 성공했을때 일정 리스트들을 올리면 된다.
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
        
        schedules = [
            ScheduleList(title: "한강공원", location: "여의도한강공원", startTime: "2024-09-23T02:09:19.849", scheduleSeq: 1, feedGet: false),
            ScheduleList(title: "독서모임", location: "교보문고 광화문점", startTime: "2024-09-23T10:00:00.000", scheduleSeq: 2, feedGet: true),
            ScheduleList(title: "기획 미팅", location: "회사", startTime: "2024-09-24T11:00:00.000", scheduleSeq: 3, feedGet: false),
            ScheduleList(title: "회사 회식", location: "마포갈비집", startTime: "2024-09-24T18:00:00.000", scheduleSeq: 4, feedGet: false)
        ]
        
        groupedSchedules = Dictionary(grouping: schedules, by: { schedule -> String in
            return String(schedule.startTime.prefix(10))
        })
        
        delegate?.didUpdateSchedules()
    }
    
    func numberOfSections() -> Int {
        return groupedSchedules.keys.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let key = Array(groupedSchedules.keys)[section]
        return groupedSchedules[key]?.count ?? 0
    }
    
    // 섹션 헤더(날짜)를 반환
    func titleForHeader(in section: Int) -> String {
        let key = Array(groupedSchedules.keys)[section]
        return key.replacingOccurrences(of: "-", with: ".")
    }
    
    // 특정 셀에 대한 일정 데이터를 반환
    func schedule(for indexPath: IndexPath) -> ScheduleList {
        let key = Array(groupedSchedules.keys)[indexPath.section]
        return groupedSchedules[key]![indexPath.row]
    }
    
    // 일정 선택시 호출
    func selectSchedule(at indexPath: IndexPath) {
        let key = Array(groupedSchedules.keys)[indexPath.row]
        let schedule = groupedSchedules[key]![indexPath.row]
        
        if !schedule.feedGet {
            selectedScheduleSeq = schedule.scheduleSeq
        }
    }
}
