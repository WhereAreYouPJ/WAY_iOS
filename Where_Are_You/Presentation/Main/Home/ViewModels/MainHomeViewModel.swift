//
//  MainHomeViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class MainHomeViewModel {
    // MARK: - Properties
    private let getDDayScheduleUseCase: GetDDayScheduleUseCase
    
    private var images: [UIImage] = []
    private var dDays: [DDay] = []
    private var feeds: [Feed] = []

    var onBannerDataFetched: (() -> Void)?
    var onDDayDataFetched: (() -> Void)?
    var onFeedsDataFetched: (() -> Void)?
    
    init(getDDayScheduleUseCase: GetDDayScheduleUseCase) {
        self.getDDayScheduleUseCase = getDDayScheduleUseCase
    }
    
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
        getDDayScheduleUseCase.execute { result in
            switch result {
            case .success(let data):
                self.dDays = data.map { data in
                    return DDay(date: data.dDay, title: data.title)
                }
                self.onDDayDataFetched?()
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }

    // 피드를 불러오는 메서드
    private func fetchFeeds() {
        // 예시 피드 데이터 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.feeds = [
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서1"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서2"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서3"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서4"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서5"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서6"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서7"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서8"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서9"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서10"),
            Feed(profileImage: UIImage(named: "exampleProfileImage")!, date: nil, location: "여의도한강공원", title: "96조 네번째 피크닉 다녀온 날", feedImages: nil, description: "정말 간만에 다녀온 96즈끼리 다녀온 여의도한강공원! 너무 간만이라 치킨 피자 어디에서 가져오는지도 헷갈리고 돗자리 깔 타이밍에 뭔 바람이 그렇게 부는지도 모르는 사이에 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서 어쩌고 저쩌고 그래서11")
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
