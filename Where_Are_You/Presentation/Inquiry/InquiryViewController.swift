//
//  InquiryViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/5/2025.
//

import UIKit

class InquiryViewController: UIViewController {
    // MARK: - Properties

    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let inquiryInfoImage1: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "inquiryImage1")
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .vertical)
        return iv
    }()
    
    let inquiryInfoImage2: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "inquiryImage2")
//        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .vertical)
        return iv
    }()
    
    let inquiryInfoImage3: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "inquiryImage3")
        iv.contentMode = .scaleAspectFit
        iv.setContentHuggingPriority(.required, for: .vertical)
        return iv
    }()
    
    let bottomButtonView = TitleButton(title: UIFont.CustomFont.button18(text: "카카오채널 바로가기", textColor: .white), backgroundColor: .brandColor, borderColor: nil)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar(title: "1:1 이용문의", backButtonAction: #selector(backButtonTapped))
        configureViewComponents()
        setupConstraints()
        buttonActions()
    }
    
    private func configureViewComponents() {
        scrollView.alwaysBounceVertical = true
        scrollView.showsVerticalScrollIndicator = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(inquiryInfoImage1)
        contentView.addSubview(inquiryInfoImage2)
        contentView.addSubview(inquiryInfoImage3)
        view.addSubview(bottomButtonView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomButtonView.snp.top).offset(LayoutAdapter.shared.scale(value: 12))
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        inquiryInfoImage1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
//            make.height.equalTo(inquiryInfoImage1.snp.width).multipliedBy(0.815)
        }
        
        inquiryInfoImage2.snp.makeConstraints { make in
            make.top.equalTo(inquiryInfoImage1.snp.bottom).offset(LayoutAdapter.shared.scale(value: 20))
            make.leading.trailing.equalToSuperview()
//            make.height.equalTo(inquiryInfoImage2.snp.width).multipliedBy(0.754)
        }
        
        inquiryInfoImage3.snp.makeConstraints { make in
            make.top.equalTo(inquiryInfoImage2.snp.bottom).offset(LayoutAdapter.shared.scale(value: 20))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
            make.bottom.equalToSuperview()
//            make.height.equalTo(inquiryInfoImage3.snp.width).multipliedBy(0.171)
        }
        
        bottomButtonView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
    
    private func buttonActions() {
        bottomButtonView.addTarget(self, action: #selector(moveToKakaoChat), for: .touchUpInside)
    }
    
    // MARK: - Selectors

    @objc func backButtonTapped() {
        popViewController()
    }
    
    @objc func moveToKakaoChat() {
        // 카카오 채팅으로 넘어가기
    }
}
