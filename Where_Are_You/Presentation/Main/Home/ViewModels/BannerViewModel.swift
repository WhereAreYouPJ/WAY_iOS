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
    private var banners: [UIImage] = []
    private var timer: Timer?
    private(set) var currentIndex = 0
    
    // MARK: - Helpers
    
    // 배너 이미지를 불러오는 메서드
    func fetchBannerImages() {
        // 예시 이미지 로딩 (나중에 실제 데이터를 로딩하는 로직으로 대체)
        self.banners = [
            UIImage(named: "exampleBanner")!,
            UIImage(named: "exampleBanner")!,
            UIImage(named: "exampleBanner")!
        ]
        onBannerDataFetched?()
        startAutoScroll()
    }
    
    func getBannerImages() -> [UIImage] {
        return banners
    }
    
    func setBannerImages(_ banners: [UIImage]) {
        self.banners = banners
        onBannerDataFetched?()
        startAutoScroll()
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
        guard !banners.isEmpty else { return }
        currentIndex = (currentIndex + 1) % banners.count
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
