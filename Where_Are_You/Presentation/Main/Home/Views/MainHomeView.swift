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
    let titleView = TitleView()
    let bannerView = BannerView()
    let dDayView = DDayView()
    let reminderLabel = StandardLabel(UIFont: UIFont.CustomFont.titleH3(text: "함께한 추억을 확인해보세요!", textColor: .black22))
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
        backgroundColor = .white
        
        addSubview(titleView)
        addSubview(bannerView)
        addSubview(dDayView)
        addSubview(reminderLabel)
        addSubview(homeFeedView)
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(2)
//            make.leading.trailing.equalTo(titleView)
            make.centerX.equalToSuperview()
            make.width.equalTo(LayoutAdapter.shared.scale(value: 327))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 180))
//            make.height.equalTo(bannerView.snp.width).multipliedBy(180.0 / 327.0)
        }
        
        dDayView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.leading.trailing.equalTo(titleView)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
        
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(dDayView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 32))
            make.leading.trailing.equalTo(titleView)
        }
        
        homeFeedView.snp.makeConstraints { make in
            make.top.equalTo(reminderLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 16))
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
