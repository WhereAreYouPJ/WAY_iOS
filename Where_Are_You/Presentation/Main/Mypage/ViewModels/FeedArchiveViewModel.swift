//
//  FeedArchiveViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/12/2024.
//

import Foundation

class FeedArchiveViewModel {
    // MARK: - Properties

    private let deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase
    private let deleteHideFeedUseCase: DeleteHideFeedUseCase
    
    private(set) var displayBookMarkFeedContent: [Feed] = [] {
        didSet {
            self.onArchiveFeedUpdated?()
        }
    }
    
    var onArchiveFeedUpdated: (() -> Void)?
    
    // MARK: - init

    init(deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase,
         deleteHideFeedUseCase: DeleteHideFeedUseCase) {
        self.deleteBookMarkFeedUseCase = deleteBookMarkFeedUseCase
        self.deleteHideFeedUseCase = deleteHideFeedUseCase
    }
    
    // MARK: - Helpers
    
    func deleteBookMarkFeed(feedSeq: Int) {
        deleteHideFeedUseCase.execute(feedSeq: feedSeq) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
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
                self.onArchiveFeedUpdated?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
