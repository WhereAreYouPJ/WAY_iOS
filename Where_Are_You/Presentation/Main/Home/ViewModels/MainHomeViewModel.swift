import Foundation
import UIKit

class MainHomeViewModel {
    // MARK: - Properties

    private var images: [UIImage] = []
    private var dDays: [DDay] = []
    private var feeds: [Feed] = []

    var onBannerDataFetched: (() -> Void)?
    var onDDayDataFetched: (() -> Void)?
    var onFeedsDataFetched: (() -> Void)?
    
    // MARK: - Helpers
    
    func loadData() {
        fetchBannerImages()
        fetchDDays()
        fetchFeeds()
    }

    // 배너 이미지를 불러오는 메서드
    func fetchBannerImages() {
        // 예시 이미지 로딩 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.images = [
            UIImage(named: "exampleBanner")!,
            UIImage(named: "exampleBanner")!,
            UIImage(named: "exampleBanner")!
        ]
        onBannerDataFetched?()
    }

    private func fetchDDays() {
        // 예시 일정 데이터 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        self.dDays = [
            DDay(date: dateFormatter.date(from: "2025-12-31")!, title: "96조 여의도 한강공원 모임"),
            DDay(date: dateFormatter.date(from: "2024-10-10")!, title: "96조 워크숍")
        ]
        onDDayDataFetched?()
    }

    // 피드를 불러오는 메서드
    private func fetchFeeds() {
        // 예시 피드 데이터 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.feeds = [
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "장소3", title: "제목3", description: "내용3"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네")
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네"),
//            Feed(profileImage: UIImage(named: "exampleProfileImage")!, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 참 좋네")
        ]
        onFeedsDataFetched?()
    }
    
    func getBannerImages() -> [UIImage] {
        return images
    }

    func getDDays() -> [DDay] {
        return dDays
    }

    func getFeeds() -> [Feed] {
        return feeds
    }
}
