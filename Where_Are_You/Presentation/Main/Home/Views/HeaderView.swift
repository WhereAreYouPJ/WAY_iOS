//
//  HeaderView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/7/2024.
//

import UIKit
import SnapKit

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
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
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
        
        separateView.snp.makeConstraints { make in
            make.top.equalTo(scheduleView.snp.bottom).offset(14)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(4).priority(.low)
            make.bottom.equalToSuperview()
        }
    }
}
