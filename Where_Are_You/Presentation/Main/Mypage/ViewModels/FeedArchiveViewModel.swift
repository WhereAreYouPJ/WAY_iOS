//
//  FeedArchiveViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/12/2024.
//

import Foundation

class FeedArchiveViewModel {
    // MARK: - Properties
    private var page: Int32 = 0
    private var isLoading = false
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    private var rawArchiveFeedContent: [HideFeedContent] =  []
    private(set) var displayArchiveFeedContent: [Feed] = [] {
        didSet {
            self.onArchiveFeedUpdated?()
        }
    }
    
    private let deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase
    private let deleteHideFeedUseCase: DeleteHideFeedUseCase
    private let deleteFeedUseCase: DeleteFeedUseCase
    private let getHideFeedUseCase: GetHideFeedUseCase
    
    var onArchiveFeedUpdated: (() -> Void)?
    
    // MARK: - init

    init(deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase,
         deleteHideFeedUseCase: DeleteHideFeedUseCase,
         deleteFeedUseCase: DeleteFeedUseCase,
         getHideFeedUseCase: GetHideFeedUseCase) {
        self.deleteBookMarkFeedUseCase = deleteBookMarkFeedUseCase
        self.deleteHideFeedUseCase = deleteHideFeedUseCase
        self.deleteFeedUseCase = deleteFeedUseCase
        self.getHideFeedUseCase = getHideFeedUseCase
    }
    
    // MARK: - Helpers
    func fetchArchiveFeed() {
        getHideFeedUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                self.page += 1
                self.rawArchiveFeedContent = data
                self.displayArchiveFeedContent.append(contentsOf: data.compactMap { $0.toFeeds() })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFeed(feedSeq: Int) {
        deleteFeedUseCase.execute(request: DeleteFeedRequest(memberSeq: memberSeq, feedSeq: feedSeq)) { [weak self] result in
            switch result {
            case .success:
                if let index = self?.displayArchiveFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                    self?.displayArchiveFeedContent.remove(at: index)
                }
                self?.onArchiveFeedUpdated?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteBookMarkFeed(feedSeq: Int) {
        deleteHideFeedUseCase.execute(feedSeq: feedSeq) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if let index = self.displayArchiveFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                    self.displayArchiveFeedContent.remove(at: index)
                }
                self.onArchiveFeedUpdated?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func restoreFeed(feedSeq: Int) {
        deleteHideFeedUseCase.execute(feedSeq: feedSeq) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                if let index = self.displayArchiveFeedContent.firstIndex(where: { $0.feedSeq == feedSeq }) {
                    self.displayArchiveFeedContent.remove(at: index)
                }
                self.onArchiveFeedUpdated?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
