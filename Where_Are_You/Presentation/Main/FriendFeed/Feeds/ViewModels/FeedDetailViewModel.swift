//
//  FeedDetailViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/8/2024.
//

import UIKit

class FeedDetailViewModel {
    var onFeedsDataFetched: (() -> Void)?
    var onFeedImagesUpdated: (([UIImage]) -> Void)?
    var onCurrentImageIndexChanged: ((Int) -> Void)?
    
    private(set) var feeds: [Feed] = [] {
        didSet {
            self.onFeedsDataFetched?()
            updateFeedImagesForCurrentIndex()
        }
    }
    
    // 현재 피드의 인덱스
    private(set) var currentFeedIndex = 0 {
        didSet {
            updateFeedImagesForCurrentIndex()
        }
    }
    
    private(set) var currentImageIndex = 0 {
        didSet {
            onCurrentImageIndexChanged?(currentImageIndex)
        }
    }
    
    // MARK: - Helpers
    
    // 서버에서 피드 데이터를 가져오는 메서드
    func fetchFeeds() {
        // 데이터 가져오기 로직 구현
        // 예시를 위해 모의 데이터를 사용합니다.
        let mockFeeds = [Feed(profileImage: UIImage(named: "exampleProfileImage") ?? UIImage(),
                              date: "2024-08-12T02:25:28.272Z",
                              location: "Seoul",
                              title: "Beautiful Seoul",
                              feedImages: [UIImage(named: "exampleFeedImage") ?? UIImage()],
                              description: "A great view of Seoul."),
                         Feed(profileImage: UIImage(named: "exampleProfileImage") ?? UIImage(),
                              date: "2024-08-12T02:25:28.272Z",
                              location: "Seoul",
                              title: "Beautiful Seoul",
                              feedImages: [UIImage(named: "exampleFeedImage") ?? UIImage()],
                              description: "A great view of Seoul.")]
        self.feeds = mockFeeds
        updateFeedImagesForCurrentIndex()
    }
    
    private func updateFeedImagesForCurrentIndex() {
        guard currentFeedIndex < feeds.count else { return }
        let feedImages = feeds[currentFeedIndex].feedImages ?? []
        onFeedImagesUpdated?(feedImages)
    }
    
    // 피드의 현재 인덱스를 업데이트하는 메서드
    func setCurrentFeedIndex(_ index: Int) {
        self.currentFeedIndex = index
    }
    
    // 이미지 인덱스 업데이트 메서드 추가
    func updateImageIndex(to index: Int) {
        currentImageIndex = index
    }
}
    //    func fetchFeeds(completion: @escaping (Result<[FeedResponse], Error>) -> Void) {
    //        // 실제 네트워크 요청을 통해 데이터를 가져오는 예제를 대신하여 모의 데이터를 사용합니다.
    //        let feedResponses = [
    //            FeedResponse(profileImage: "base64String1", date: "2024-08-12T02:25:28.272Z", location: "Seoul", title: "Title 1", feedImages: ["base64String2"], description: "Description 1")
    //        ]
    //
    //        // 데이터를 성공적으로 가져온 경우
    //        completion(.success(feedResponses))
    //    }
    
    // 피드를 가져와서 변환하는 메서드
    //    func loadFeeds() {
    //        fetchFeeds { [weak self] result in
    //            switch result {
    //            case .success(let feedResponses):
    //                // FeedResponse를 Feed로 변환
    //                self?.feeds = feedResponses.map { self?.convertToFeed(from: $0) }.compactMap { $0 }
    //                self?.feeds[0].profileImage = UIImage(named: "exampleProfileImage")!
    //                self?.feeds[0].feedImages = [UIImage(named: "exampleFeedImage")!]
    //                self?.onFeedsDataFetched?() // UI 업데이트를 위한 콜백 호출
    //            case .failure(let error):
    //                print("Error fetching feeds: \(error)")
    //            }
    //        }
    //    }
    //    private func convertToFeed(from response: FeedResponse) -> Feed {
    //        let profileImage = response.profileImage.flatMap { ImageUtility.decodeBase64StringToImage($0) }!
    //
    //        let dateFormatter = ISO8601DateFormatter()
    //        let date = dateFormatter.date(from: response.date) // ISO 8601 형식으로 변환
    //
    //        let feedImages = response.feedImages.compactMap { ImageUtility.decodeBase64StringToImage($0) }
    //
    //        return Feed(profileImage: profileImage, date: date, location: response.location, title: response.title, feedImages: feedImages, description: response.description)
    //    }
