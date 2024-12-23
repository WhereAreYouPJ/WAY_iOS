//
//  FeedBookMarkViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/11/2024.
//

import Foundation
protocol FeedBookMarkViewModelDelegate: AnyObject {
    func didUpdateBookMarkFeed()
}

class FeedBookMarkViewModel {
    // MARK: - Properties
    private var page: Int32 = 0
    private var isLoading = false
    
    private var rawBookMarkFeedContent: [BookMarkContent] = []
    private(set) var displayBookMarkFeedContent: [Feed] = [] {
        didSet {
            self.onBookMarkFeedUpdated?()
        }
    }
    weak var delegate: FeedBookMarkViewModelDelegate?
    
    var onBookMarkFeedUpdated: (() -> Void)?
    
    private let getBookMarkFeedUseCase: GetBookMarkFeedUseCase
    private let deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase
    
    // MARK: - Init
    init(getBookMarkFeedUseCase: GetBookMarkFeedUseCase,
         deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase) {
        self.getBookMarkFeedUseCase = getBookMarkFeedUseCase
        self.deleteBookMarkFeedUseCase = deleteBookMarkFeedUseCase
    }
    
    // MARK: - Helepers
    func fetchBookMarkFeed() {
        getBookMarkFeedUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let data):
                self.page += 1
                self.rawBookMarkFeedContent = data
                
                self.displayBookMarkFeedContent = rawBookMarkFeedContent.compactMap { $0.toFeeds() }
                self.onBookMarkFeedUpdated?()
                self.delegate?.didUpdateBookMarkFeed()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteBookMarkFeed(feedSeq: Int) {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        deleteBookMarkFeedUseCase.execute(request: BookMarkFeedRequest(feedSeq: feedSeq, memberSeq: memberSeq)) { result in
            switch result {
            case .success:
                self.onBookMarkFeedUpdated?()
                self.delegate?.didUpdateBookMarkFeed()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
