//
//  FriendFeedTitleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 12/6/2025.
//

import UIKit

class FriendFeedTitleView: UIView {
    
    let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "피드", at: 0, animated: false)
        sc.insertSegment(withTitle: "친구", at: 1, animated: false)
        sc.selectedSegmentIndex = 0
        
        // CustomFont.titleH1이 리턴하는 attributedString에서 속성 딕셔너리 추출
        let normalAttributes = UIFont.CustomFont.titleH1(text: "피드", textColor: .blackAC).attributes(at: 0, effectiveRange: nil)
        let selectedAttributes = UIFont.CustomFont.titleH1(text: "피드", textColor: .black22).attributes(at: 0, effectiveRange: nil)
        
        sc.setTitleTextAttributes(normalAttributes, for: .normal)
        sc.setTitleTextAttributes(selectedAttributes, for: .selected)
        
        sc.selectedSegmentTintColor = .clear
        sc.backgroundColor = .clear
        let image = UIImage()
        sc.setBackgroundImage(image, for: .normal, barMetrics: .default)
        sc.setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        return sc
    }()
    
    let searchFriendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-search"), for: .normal)
        button.tintColor = .brandColor
        return button
    }()
    
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-notification"), for: .normal)
        button.tintColor = .brandColor
        return button
    }()
    
    let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-plus"), for: .normal)
        button.tintColor = .brandColor
        return button
    }()
    
    private lazy var barButtonStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [searchFriendButton, notificationButton, addButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(segmentControl)
        addSubview(barButtonStack)
    }
    
    private func setupConstraints() {
        segmentControl.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 13))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 32))
            make.height.equalTo(29)
        }
        
        barButtonStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15.5))
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 24))
        }
    }
}
