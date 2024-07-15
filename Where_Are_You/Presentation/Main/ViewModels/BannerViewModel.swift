//
//  BannerViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation
import UIKit

import Foundation
import UIKit

class BannerViewModel {
    var onBannerDataFetched: (() -> Void)?
    private var bannerImages: [UIImage] = []
    private var timer: Timer?

    func fetchBannerImages() {
        // Fetch banner images from the API
        // Update bannerImages array
        self.bannerImages = [
            UIImage(named: "banner1")!,
            UIImage(named: "banner1")!
        ]
        onBannerDataFetched?()
    }

    func getBannerImages() -> [UIImage] {
        return bannerImages
    }

    func startAutoScroll() {
        stopAutoScroll()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }

    func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func scrollToNextPage() {
        // Logic to automatically scroll to the next page
    }
}
