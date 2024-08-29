//
//  BannerViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class BannerViewModel {
    // MARK: - Properties
    
    var onBannerDataFetched: (() -> Void)?
    private var bannerImages: [UIImage] = []
    private var timer: Timer?
    private(set) var currentIndex = 0
    
    // MARK: - Helpers
    
    // 데이터 설정 메서드
    func setBanners(_ banners: [UIImage]) {
        self.bannerImages = banners
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
    
    // currentIndex를 업데이트하는 메서드 추가
    func updateCurrentIndex(to newIndex: Int) {
        currentIndex = newIndex
    }
    
    // MARK: - Selectors
    
    @objc private func scrollToNextPage() {
        guard !bannerImages.isEmpty else { return }
        currentIndex = (currentIndex + 1) % bannerImages.count
        let indexPath = IndexPath(item: currentIndex + 1, section: 0) // +1 to account for fake cells
        NotificationCenter.default.post(name: .scrollToBannerIndex, object: nil, userInfo: ["indexPath": indexPath])
    }
    
    deinit {
        stopAutoScroll()
    }
}

extension Notification.Name {
    static let scrollToBannerIndex = Notification.Name("scrollToBannerIndex")
}
