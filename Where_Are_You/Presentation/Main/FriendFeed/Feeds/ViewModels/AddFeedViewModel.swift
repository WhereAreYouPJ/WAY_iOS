//
//  AddFeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/8/2024.
//

import UIKit

protocol AddFeedViewModelDelegate: AnyObject {
    func didUpdateSchedules()
}

class AddFeedViewModel {
    private let getScheduleListUseCase: GetScheduleListUseCase
    private let saveFeedUseCase: SaveFeedUseCase
    
    private var schedules: [ScheduleContent] = []
    private var page: Int32 = 0
    private var isLoading = false
    
    private var groupedSchedules: [String: [ScheduleContent]] = [:]
    var selectedScheduleSeq: Int?
    var selectedSchedule: ScheduleContent?
    var selectedImages: [UIImage] = []
    
    var onSchedulesUpadated: (() -> Void)?
    
    weak var delegate: AddFeedViewModelDelegate?
    
    // MARK: - Lifecycle
    init(getScheduleListUseCase: GetScheduleListUseCase, saveFeedUseCase: SaveFeedUseCase) {
        self.getScheduleListUseCase = getScheduleListUseCase
        self.saveFeedUseCase = saveFeedUseCase
    }
    
    // MARK: - Helpers
    
    func fetchSchedules() {
        guard !isLoading else { return }
        isLoading = true
        
        getScheduleListUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let newSchedules):
                self.schedules.append(contentsOf: newSchedules)
                self.page += 1
                
                // 데이터 그룹화 (날짜별로)
                self.groupedSchedules = Dictionary(grouping: schedules, by: { schedule -> String in
                    return String(schedule.startTime.prefix(10))
                })
                self.onSchedulesUpadated?()
                self.delegate?.didUpdateSchedules()
                // 여기에 성공했을때 일정 리스트들을 올리면 된다.
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
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
    func schedule(for indexPath: IndexPath) -> ScheduleContent {
        let key = Array(groupedSchedules.keys)[indexPath.section]
        return groupedSchedules[key]![indexPath.row]
    }
    
    // 일정 선택시 호출
    func selectSchedule(at indexPath: IndexPath) {
        let key = Array(groupedSchedules.keys)[indexPath.row]
        let schedule = groupedSchedules[key]![indexPath.row]
        
        if !schedule.feedExists {
            selectedScheduleSeq = schedule.scheduleSeq
            selectedSchedule = schedule
            onSchedulesUpadated?() // 선택된 일정 정보 업데이트 알림
        }
    }
    
    // 피드 저장 메서드
    func saveFeed(title: String, content: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let schedule = selectedSchedule else { return }
        
        let request = SaveFeedRequest(scheduleSeq: schedule.scheduleSeq,
                                      memberSeq: UserDefaultsManager.shared.getMemberSeq(),
                                      title: title,
                                      content: content,
                                      feedImageOrders: [])
        
        saveFeedUseCase.execute(request: request, images: selectedImages, completion: completion)
    }
}
