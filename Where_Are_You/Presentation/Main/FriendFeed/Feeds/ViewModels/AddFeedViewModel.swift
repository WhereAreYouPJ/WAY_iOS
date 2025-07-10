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
    private let getScheduleUseCase: GetScheduleUseCase
    
    private var participants: [String] = [] // 참가자 이름을 저장할 배열
    private var schedules: [ScheduleContent] = []
    private var sectionKeys: [String] = []
    private var page: Int32 = 0
    private var isLoading = false
    
    private var groupedSchedules: [String: [ScheduleContent]] = [:]
    var selectedScheduleSeq: Int?
    var selectedSchedule: ScheduleContent?
    var selectedImages: [UIImage] = []
    
    var onSchedulesUpdated: (() -> Void)?
    var onFeedCreated: (() -> Void)?
    
    weak var delegate: AddFeedViewModelDelegate?
    
    // MARK: - Lifecycle
    init(getScheduleListUseCase: GetScheduleListUseCase, saveFeedUseCase: SaveFeedUseCase, getScheduleUseCase: GetScheduleUseCase) {
        self.getScheduleListUseCase = getScheduleListUseCase
        self.saveFeedUseCase = saveFeedUseCase
        self.getScheduleUseCase = getScheduleUseCase
    }
    
    // MARK: - Helpers
    private func updateGroupedSchedules() {
        // 날짜 기준 그룹화
        groupedSchedules = Dictionary(grouping: schedules, by: { schedule in
            String(schedule.startTime.prefix(10))
        })
        // 날짜 내림차순 정렬 (최신 날짜가 먼저 오도록)
        sectionKeys = groupedSchedules.keys.sorted(by: >)
    }
    
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
                
                // 일정 배열을 최신 날짜 순으로 정렬 (날짜가 최신인 일정이 상단에 위치)
                self.schedules.sort { $0.startTime > $1.startTime }
                // 데이터 그룹화 (날짜별로)
                self.updateGroupedSchedules() // 💥 여기서 keys도 같이 세팅
                
                DispatchQueue.main.async {
                    self.onSchedulesUpdated?()
                    self.delegate?.didUpdateSchedules()
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func numberOfSections() -> Int {
        return sectionKeys.count
    }
    
    func numberOfRows(in section: Int) -> Int {
        let key = sectionKeys[section]
        return groupedSchedules[key]?.count ?? 0
    }
    
    // 섹션 헤더(날짜)를 반환
    func titleForHeader(in section: Int) -> String {
        return sectionKeys[section].replacingOccurrences(of: "-", with: ".")
    }
    
    // 특정 셀에 대한 일정 데이터를 반환
    func schedule(for indexPath: IndexPath) -> ScheduleContent {
        guard sectionKeys.indices.contains(indexPath.section) else {
            fatalError("Invalid section index: \(indexPath.section)")
        }
        
        let key = sectionKeys[indexPath.section]
        guard let schedulesForSection = groupedSchedules[key],
              indexPath.row < schedulesForSection.count else {
            fatalError("Invalid row index: \(indexPath)")
        }
        print("🟡 sectionKeys.count = \(sectionKeys.count)")
        print("🟡 schedulesForSection.count = \(schedulesForSection.count), indexPath = \(indexPath)")
        return schedulesForSection[indexPath.row]
    }
    
    // 일정 선택시 호출
    func selectSchedule(at indexPath: IndexPath) {
        let key = Array(groupedSchedules.keys)[indexPath.section]
        if let schedule = groupedSchedules[key]?[indexPath.row] {
            if !schedule.feedExists {
                selectedScheduleSeq = schedule.scheduleSeq
                selectedSchedule = schedule
                onSchedulesUpdated?() // 선택된 일정 정보 업데이트 알림
            }
        }
    }
    
    // 참가자 정보 가져오기 메서드 추가
    func fetchParticipants(for scheduleSeq: Int, completion: @escaping () -> Void) {
        getScheduleUseCase.execute(scheduleSeq: scheduleSeq) { result in
            switch result {
            case .success(let data):
                let memberSeq = UserDefaultsManager.shared.getMemberSeq()
                self.participants = data.memberInfos.filter { $0.memberSeq != memberSeq }.map { $0.userName }
                completion()
            case .failure(let error):
                print(error.localizedDescription)
                completion()
            }
        }
    }
    
    // 참가자 정보 가져오기
    func getParticipants() -> String {
        guard participants.count > 0 else {
            print("participants is Empty")
            return ""
        }
        
        if participants.count > 3 {
            let displayedNames = participants.prefix(3).joined(separator: ", ")
            return "\(displayedNames) 외 \(participants.count - 3)명"
        } else {
            return participants.joined(separator: ", ")
        }
    }
    
    // 전체 행 수를 반환하는 메서드 추가
    func totalNumberOfRows() -> Int {
        return groupedSchedules.values.reduce(0) { $0 + $1.count }
    }
    
    // MARK: - 피드 저장 메서드
    func saveFeed(title: String, content: String?) {
        guard let schedule = selectedSchedule else { return }
        let feedImageOrders: [Int]? = selectedImages.isEmpty ? nil : Array(0..<selectedImages.count)
        
        let request = SaveFeedRequest(scheduleSeq: schedule.scheduleSeq,
                                      memberSeq: UserDefaultsManager.shared.getMemberSeq(),
                                      title: title,
                                      content: content,
                                      feedImageOrders: feedImageOrders)
        
        saveFeedUseCase.execute(request: request, images: selectedImages) { result
            in
            switch result {
            case .success:
                self.onFeedCreated?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
