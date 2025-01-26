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
    let dDayView = DDayView()
    let reminderLabel = CustomLabel(UILabel_NotoSans: .medium, text: "함께한 추억을 확인해보세요!", textColor: .black22, fontSize: LayoutAdapter.shared.scale(value: 20))
    let homeFeedView = HomeFeedView()
    let bottomSheetView = BottomSheetView()
    
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
        
        addSubview(bannerView)
        addSubview(dDayView)
        addSubview(reminderLabel)
        addSubview(homeFeedView)
        
//        addSubview(dimView)
        addSubview(bottomSheetView)
    }
    
    private func setupConstraints() {
        bannerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(self.snp.width).multipliedBy(0.507)
        }
        
        dDayView.snp.makeConstraints { make in
            make.top.equalTo(bannerView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 15))
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 52))
        }
        
        reminderLabel.snp.makeConstraints { make in
            make.top.equalTo(dDayView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 20))
            make.leading.trailing.equalToSuperview().inset(15)
        }
        
        homeFeedView.snp.makeConstraints { make in
            make.top.equalTo(reminderLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 15))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 272))
        }
        
//        dimView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
        
        bottomSheetView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
