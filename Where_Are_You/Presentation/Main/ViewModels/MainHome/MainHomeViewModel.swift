import Foundation
import UIKit

class MainHomeViewModel {
    // MARK: - Properties

    private var images: [UIImage] = []
    private var schedules: [String] = []
    private var feeds: [String] = []

    var onBannerDataFetched: (() -> Void)?
    var onScheduleDataFetched: (() -> Void)?
    var onFeedsDataFetched: (() -> Void)?
    
    // MARK: - Helpers

    // 배너 이미지를 불러오는 메서드
    func fetchBannerImages() {
        // 예시 이미지 로딩 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.images = [
            UIImage(named: "banner1")!,
            UIImage(named: "banner2")!
        ]
        onBannerDataFetched?()
    }

    // 스케줄을 불러오는 메서드
    func fetchSchedules() {
        // 예시 일정 데이터 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.schedules = [
            "D - 369 96조 여의도 한강공원 모임",
            "D - 100 96조 워크숍"
        ]
        onScheduleDataFetched?()
    }

    // 피드를 불러오는 메서드
    func fetchFeeds() {
        // 예시 피드 데이터 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.feeds = [
            "여의도한강공원 96조 네번째 피크닉 다녀온 날",
            "피드 2",
            "피드 3"
        ]
        onFeedsDataFetched?()
    }
    
    func getBannerImages() -> [UIImage] {
        return images
    }

    func getSchedules() -> [String] {
        return schedules
    }

    func getFeeds() -> [String] {
        return feeds
    }
}
