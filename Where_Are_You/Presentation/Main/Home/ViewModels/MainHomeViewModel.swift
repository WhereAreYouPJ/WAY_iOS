//
//  MainHomeViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class MainHomeViewModel {
    // MARK: - Properties
    let bannerViewModel: BannerViewModel
    let dDayViewModel: DDayViewModel
    let homeFeedViewModel: HomeFeedViewModel
    
    init(bannerViewModel: BannerViewModel, dDayViewModel: DDayViewModel, homeFeedViewModel: HomeFeedViewModel) {
        self.bannerViewModel = bannerViewModel
        self.dDayViewModel = dDayViewModel
        self.homeFeedViewModel = homeFeedViewModel
    }
    
    // MARK: - Helpers
    
    func loadData() {
        bannerViewModel.fetchBannerImages()
        dDayViewModel.fetchDDays()
        homeFeedViewModel.fetchFeeds()
    }
}
