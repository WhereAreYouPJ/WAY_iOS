//
//  BannerView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import Foundation
import UIKit

class BannerView: UIView, UIScrollViewDelegate {
    
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    private var images: [UIImage] = []
    
    // MARK: - Lifecycle

    init(images: [UIImage]) {
        self.images = images
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setupViews() {
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        addSubview(scrollView)
        addSubview(pageControl)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        setupSlides()
    }
    
    private func setupSlides() {
        for (index, image) in images.enumerated() {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            scrollView.addSubview(imageView)
            
            imageView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview()
                make.width.equalToSuperview()
                make.leading.equalToSuperview().offset(CGFloat(index) * UIScreen.main.bounds.width)
            }
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(images.count), height: bounds.height)
        pageControl.numberOfPages = images.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
