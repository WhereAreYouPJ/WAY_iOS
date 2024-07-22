//
//  HeaderView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/7/2024.
//

import UIKit

class HeaderView: UIView {
    // MARK: - Properties
    
    // 배너 슬라이드 이미지
    let bannerView = BannerView()
    
    // 자동 슬라이드 일정
    let scheduleView = ScheduleView()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func setupViews() {
        addSubview(bannerView)
        addSubview(scheduleView)
        addSubview(separateView)
    }
    
    private func setupConstraints() {
        bannerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(bannerView.snp.width).multipliedBy(0.55)
        }
        
        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(scheduleView.snp.width).multipliedBy(0.15)
        }
        
        // 분리선 넣기
        separateView.snp.makeConstraints { make in
            make.top.equalTo(scheduleView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4)
            make.bottom.equalToSuperview()
        }
    }
    
    // Calculate the total height of the header view based on its contents
    func calculateHeight() -> CGFloat {
        let bannerHeight = UIScreen.main.bounds.width * 0.55
        let scheduleHeight = UIScreen.main.bounds.width * 0.15
        let separatorHeight: CGFloat = 4
        let totalHeight = bannerHeight + scheduleHeight + separatorHeight + 15 + 15 + 14 // Including offsets
        return totalHeight
    }
}
