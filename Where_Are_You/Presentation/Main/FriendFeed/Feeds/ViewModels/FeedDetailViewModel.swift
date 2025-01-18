//
//  FeedDetailViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/8/2024.
//

import UIKit

class FeedDetailViewModel {
    private let getFeedDetailsUseCase: GetFeedDetailsUseCase
    private let deleteFeedUseCase: DeleteFeedUseCase
    private let postHideFeedUseCase: PostHideFeedUseCase
    
    private let postBookMarkFeedUseCase: PostBookMarkFeedUseCase
    private let deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase
    
    var onFeedsDataFetched: (() -> Void)?
    var onFeedImagesUpdated: (([UIImage]) -> Void)?
    var onCurrentImageIndexChanged: ((Int) -> Void)?
    
    private var page: Int32 = 0
    private var isLoading = false
    
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    private(set) var displayFeedContent: [Feed] = [] {
        didSet {
            DispatchQueue.main.async {
                self.onFeedsDataFetched?()
            }
        }
    }
    
    private var participants: [Info] = []
    
    // MARK: - Lifecycle
    init(getFeedDetailsUseCase: GetFeedDetailsUseCase,
         deleteFeedUseCase: DeleteFeedUseCase,
         postHideFeedUseCase: PostHideFeedUseCase,
         postBookMarkFeedUseCase: PostBookMarkFeedUseCase,
         deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase) {
        self.getFeedDetailsUseCase = getFeedDetailsUseCase
        self.deleteFeedUseCase = deleteFeedUseCase
        self.postHideFeedUseCase = postHideFeedUseCase
        self.postBookMarkFeedUseCase = postBookMarkFeedUseCase
        self.deleteBookMarkFeedUseCase = deleteBookMarkFeedUseCase
    }
    
    // MARK: - Helpers
    
    // 서버에서 피드 데이터를 가져오는 메서드
    func fetchDetailFeeds(scheduleSeq: Int) {
        getFeedDetailsUseCase.execute(scheduleSeq: scheduleSeq, memberSeq: memberSeq) { result in
            switch result {
            case .success(let data):
                let rawFeedContent: FeedContent = data
                let scheduleFeedInfo = rawFeedContent.scheduleFeedInfo
                self.participants = rawFeedContent.scheduleFriendInfo
                self.displayFeedContent = scheduleFeedInfo.compactMap({
                    return Feed(scheduleSeq: rawFeedContent.scheduleInfo.scheduleSeq,
                                feedSeq: $0.feedInfo.feedSeq,
                                memberSeq: $0.memberInfo.memberSeq,
                                startTime: rawFeedContent.scheduleInfo.startTime,
                                profileImageURL: $0.memberInfo.profileImageURL,
                                location: rawFeedContent.scheduleInfo.location,
                                title: $0.feedInfo.title,
                                content: $0.feedInfo.content,
                                bookMark: $0.bookMarkInfo,
                                scheduleFriendInfos: rawFeedContent.scheduleFriendInfo,
                                feedImageInfos: $0.feedImageInfos)
                })
                self.onFeedsDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //    func getParticipantFeed(index: Int) -> Feed {
    //        return displayFeedContent[index]
    //    }
    
    func getParticipants() -> [Info] {
        return participants
    }
    
    // 특정 참가자의 피드 작성 여부 확인
    func hasParticipantFeed(index: Int) -> Bool {
        guard index < participants.count else { return false }
        let participantSeq = participants[index].memberSeq
        return displayFeedContent.contains { $0.memberSeq == participantSeq }
    }
    
    // 특정 참가자의 피드 반환 (작성한 경우)
    func getParticipantFeed(index: Int) -> Feed? {
        guard index < participants.count else { return nil }
        let participantSeq = participants[index].memberSeq
        return displayFeedContent.first { $0.memberSeq == participantSeq }
    }
    
    // MARK: - Delete, Hide, BookMark
    
    func deleteFeed(feedSeq: Int) {
        deleteFeedUseCase.execute(request: DeleteFeedRequest(memberSeq: memberSeq, feedSeq: feedSeq)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if let index = self.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                    self.displayFeedContent.remove(at: index)
                }
                self.onFeedsDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func hidFeed(feedSeq: Int) {
        postHideFeedUseCase.execute(feedSeq: feedSeq) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.onFeedsDataFetched?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func postFeedBookMark(feedSeq: Int) {
        postBookMarkFeedUseCase.execute(request: BookMarkFeedRequest(feedSeq: feedSeq, memberSeq: memberSeq)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self?.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                        self?.displayFeedContent[index].bookMark = true
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFeedBookMark(feedSeq: Int) {
        deleteBookMarkFeedUseCase.execute(request: BookMarkFeedRequest(feedSeq: feedSeq, memberSeq: memberSeq)) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    if let index = self?.displayFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                        self?.displayFeedContent[index].bookMark = false
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
