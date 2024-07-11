//
//  MainHomeView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit

class MainHomeView: UIView {
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(Ttangsbudae: .bold, fontSize: 20))
        label.adjustsFontForContentSizeCategory = true
        label.text = "지금 어디?"
        label.textColor = .letterBrandColor
        return label
    }()
    
    private let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_bell_notification"), for: .normal)
        return button
    }()
    
    private let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon_profile"), for: .normal)
        return button
    }()
    
    // 배너 슬라이드 이미지
    
    let bannerView = BannerView()
    
    // 자동 슬라이드 일정
    
    let scheduleView = ScheduleView()
    
    // 새로 커스텀 버튼을 만들어서 추가하기
    let reminderButton = UIButton()
    
    let feedTableView: FeedTableView
    
    // MARK: - Lifecycle
    init(feeds: [String]) {
        feedTableView = FeedTableView()
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(bannerView)
        addSubview(scheduleView)
        addSubview(reminderButton)
        addSubview(feedTableView)
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(150)
        }
        
        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        
        reminderButton.snp.makeConstraints { make in
            make.top.equalTo(scheduleView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        feedTableView.snp.makeConstraints { make in
            make.top.equalTo(reminderButton.snp.bottom).offset(16)
            make.leading.trailing.bottom.equalToSuperview().inset(16)
        }
    }
    
}
