//
//  BannerViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import Foundation
import UIKit

class BannerViewModel {
    var onBannerDataFetched: (() -> Void)?
    private var bannerImages: [UIImage] = []
    private var timer: Timer?
    private var currentIndex = 0
    
    func fetchBannerImages() {
        // Fetch banner images from the API
        // Update bannerImages array
        self.bannerImages = [
            UIImage(named: "banner1")!,
            UIImage(named: "banner1")!
        ]
        onBannerDataFetched?()
        startAutoScroll()
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
        guard !bannerImages.isEmpty else { return }
        currentIndex = (currentIndex + 1) % bannerImages.count
        let indexPath = IndexPath(item: currentIndex, section: 0)
        NotificationCenter.default.post(name: .scrollToBannerIndex, object: nil, userInfo: ["indexPath": indexPath])
    }
}

extension Notification.Name {
    static let scrollToBannerIndex = Notification.Name("scrollToBannerIndex")
}
