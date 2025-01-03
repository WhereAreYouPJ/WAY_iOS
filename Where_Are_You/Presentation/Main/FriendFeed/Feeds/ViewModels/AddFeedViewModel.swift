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
    private var page: Int32 = 0
    private var isLoading = false
    
    private var groupedSchedules: [String: [ScheduleContent]] = [:]
    var selectedScheduleSeq: Int?
    var selectedSchedule: ScheduleContent?
    var selectedImages: [UIImage] = []
    
    var onSchedulesUpdated: (() -> Void)?
    
    weak var delegate: AddFeedViewModelDelegate?
    
    // MARK: - Lifecycle
    init(getScheduleListUseCase: GetScheduleListUseCase, saveFeedUseCase: SaveFeedUseCase, getScheduleUseCase: GetScheduleUseCase) {
        self.getScheduleListUseCase = getScheduleListUseCase
        self.saveFeedUseCase = saveFeedUseCase
        self.getScheduleUseCase = getScheduleUseCase
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
                
                // 일정 배열을 최신 날짜 순으로 정렬 (날짜가 최신인 일정이 상단에 위치)
                self.schedules.sort { $0.startTime > $1.startTime }
                
                // 데이터 그룹화 (날짜별로)
                self.groupedSchedules = Dictionary(grouping: schedules, by: { schedule -> String in
                    return String(schedule.startTime.prefix(10))
                })
                self.onSchedulesUpdated?()
                self.delegate?.didUpdateSchedules()
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
                self.participants = data.memberInfos.filter { !$0.isCreate }.map { $0.userName }
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // 참가자 정보 가져오기
    func getParticipants() -> String {
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
    func saveFeed(title: String, content: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let schedule = selectedSchedule else { return }

        if selectedImages.isEmpty {
            let noFeedImageView = NoFeedImageView(frame: CGRect(x: 0, y: 0, width: 345, height: 290))
            if let profileImageURL = UserDefaultsManager.shared.getProfileImageURL() {
                noFeedImageView.configureUI(profileImage: profileImageURL)
            } else {
                // 디폴트 이미지를 설정
                let defaultImage = UIImage(named: "defaultProfileImage")
                noFeedImageView.profileImageView.image = defaultImage
                noFeedImageView.backgroundImage.image = defaultImage
            }
            
            // UIView를 UIImage로 변환
            UIGraphicsBeginImageContextWithOptions(noFeedImageView.bounds.size, noFeedImageView.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            noFeedImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            if let generatedImage = UIGraphicsGetImageFromCurrentImageContext() {
                print("Generated Image: \(generatedImage)")
                selectedImages.append(generatedImage) // `selectedImages`에 추가
            } else {
                print("Failed to generate image from NoFeedImageView.")
            }
        }
        
        let feedImageOrders = Array(0..<selectedImages.count)
        
        let request = SaveFeedRequest(scheduleSeq: schedule.scheduleSeq,
                                      memberSeq: UserDefaultsManager.shared.getMemberSeq(),
                                      title: title,
                                      content: content,
                                      feedImageOrders: feedImageOrders)
        
        saveFeedUseCase.execute(request: request, images: selectedImages, completion: completion)
    }
}
