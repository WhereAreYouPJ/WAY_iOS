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
    
    var iconStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    // 배너 슬라이드 이미지
    let bannerView = BannerView()
    
    // 자동 슬라이드 일정
    let scheduleView = ScheduleView()
    
    private let separateView: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
//    // 피드 테이블뷰
//    let feedTableView = FeedTableView()
    
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

    func setupViews() {
        backgroundColor = .white

        addSubview(titleLabel)
        addSubview(iconStack)
        iconStack.addArrangedSubview(notificationButton)
        iconStack.addArrangedSubview(profileButton)

        addSubview(bannerView)
        addSubview(scheduleView)
        addSubview(separateView)
//        addSubview(feedTableView)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(14)
            make.leading.equalToSuperview().offset(18)
            make.width.equalTo(self.snp.width).multipliedBy(0.26)
            make.height.equalTo(titleLabel.snp.width).multipliedBy(0.25)
        }
        
        iconStack.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(8)
            make.trailing.equalToSuperview().inset(11)
        }
        
        bannerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(21)
            make.leading.trailing.equalToSuperview().inset(15)
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
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(4)
        }
//        
//        feedTableView.snp.makeConstraints { make in
//            make.top.equalTo(reminderButton.snp.bottom).offset(12)
//            make.leading.trailing.bottom.equalToSuperview().inset(20)
//        }
    }
}
