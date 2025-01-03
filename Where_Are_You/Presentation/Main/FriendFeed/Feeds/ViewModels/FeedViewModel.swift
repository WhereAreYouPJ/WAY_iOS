//
//  FeedViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/11/2024.
//

import Foundation
import Kingfisher

class FeedViewModel {
    // MARK: - Properties
    private let getFeedListUseCase: GetFeedListUseCase
    private let deleteFeedUseCase: DeleteFeedUseCase
    private let postHideFeedUseCase: PostHideFeedUseCase
    
    private let postBookMarkFeedUseCase: PostBookMarkFeedUseCase
    private let deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase
    
//    private let imageCache = ImageCache.default
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    var onFeedsDataFetched: (() -> Void)?
    //    var onImageLoaded: ((Int) -> Void)?
    
    private(set) var currentIndex = 0
    
    private var page: Int32 = 0
    private var isLoading = false
    
    private var rawFeedContent: [FeedContent] = []
    private(set) var displayFeedContent: [Feed] = [] {
        didSet {
            self.onFeedsDataFetched?()
        }
    }
    
    //    var cachedImages: [Int: [UIImage]] = [:]  이미지 캐싱 저장소 (feedSeq기반)
    
    // MARK: - Initializer
    init(getFeedListUseCase: GetFeedListUseCase,
         deleteFeedUseCase: DeleteFeedUseCase,
         postHideFeedUseCase: PostHideFeedUseCase,
         postBookMarkFeedUseCase: PostBookMarkFeedUseCase,
         deleteBookMarkFeedUseCase: DeleteBookMarkFeedUseCase) {
        self.getFeedListUseCase = getFeedListUseCase
        self.deleteFeedUseCase = deleteFeedUseCase
        self.postHideFeedUseCase = postHideFeedUseCase
        self.postBookMarkFeedUseCase = postBookMarkFeedUseCase
        self.deleteBookMarkFeedUseCase = deleteBookMarkFeedUseCase
    }
    
    // MARK: - Helpers
    func fetchFeeds() {
        getFeedListUseCase.execute(page: page) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            
            switch result {
            case .success(let data):
                self.rawFeedContent = data
                self.displayFeedContent = data.compactMap { $0.toFeeds() }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
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
    
    // MARK: - Prefetch Images
    //    private func prefetchImages() {
    //        for feed in displayFeedContent {
    //            let feedSeq = feed.feedSeq
    //            // 피드의 이미지 배열 초기화
    //            cachedImages[feedSeq] = []
    //
    //            // 각 이미지 URL에 대해 로드
    //            for imageInfo in feed.feedImageInfos {
    //                let imageUrlString = imageInfo.feedImageURL
    //                guard let url = URL(string: imageUrlString) else { continue }
    //
    //                KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
    //                    switch result {
    //                    case .success(let imageResult):
    //                        // 이미지를 배열에 추가
    //                        self?.cachedImages[feedSeq]?.append(imageResult.image)
    //                        self?.onImageLoaded?(feedSeq) // 이미지 로드 콜백 호출
    //                    case .failure(let error):
    //                        print("Failed to load image: \(error.localizedDescription)")
    //                    }
    //                }
    //            }
    //        }
    //    }
    //
    //    // MARK: - Get Image
    //    func image(for feedSeq: Int, at index: Int) -> UIImage? {
    //        return cachedImages[feedSeq]?[index]
    //    }
    //
    //    private func updateFeedImagesForCurrentIndex() {
    //
    //    }
}
