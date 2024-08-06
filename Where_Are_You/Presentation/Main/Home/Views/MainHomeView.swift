//
//  MainHomeView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import UIKit
import SnapKit

class MainHomeView: UIView {
    // MARK: - Properties
    let bannerView = BannerView()
    
    let scheduleView = ScheduleView()
    
    let reminderLabel = CustomLabel(UILabel_NotoSans: .medium, text: "함께한 추억을 확인해보세요!", textColor: .color34, fontSize: 20)
    
    let homeFeedView = HomeFeedView()
    
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
        addSubview(reminderLabel)
        addSubview(homeFeedView)
    }
    
    private func setupConstraints() {
        bannerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(bannerView.snp.width).multipliedBy(0.55)
        }
        
        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(scheduleView.snp.width).multipliedBy(0.15)
        }
        
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(scheduleView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        homeFeedView.snp.makeConstraints { make in
            make.top.equalTo(reminderLabel.snp.bottom).offset(20)
            // leading, trailing 설정 해야함
        }
    }
}
