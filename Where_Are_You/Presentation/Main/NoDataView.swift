//
//  NoFeedsView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class NoDataView: UIView {
    // MARK: - Properties

    private let borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.blackD4.cgColor
        view.layer.cornerRadius = LayoutAdapter.shared.scale(value: 12)
        view.backgroundColor = .white
        return view
    }()
    
    private let logoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-yellow_OMW")
        return imageView
    }()
    
    private let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "오늘 하루 수고했던 일은 \n어떤 경험을 남기게 했나요? \n\n하루의 소중한 시간을 기록하고 \n오래 기억될 수 있도록 간직해보세요!", textColor: .blackAC))
    
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
        addSubview(borderView)
        addSubview(logoImage)
        borderView.addSubview(descriptionLabel)
        
        descriptionLabel.textAlignment = .center
    }
    
    private func setupConstraints() {
        borderView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 120))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 37))
        }
        
        logoImage.snp.makeConstraints { make in
            make.centerY.equalTo(borderView.snp.top)
            make.centerX.equalTo(borderView)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 56))
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 42))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 26))
            make.centerX.equalToSuperview()
        }
    }
    
    func configureUI(descriptionText: String) {
        descriptionLabel.attributedText = UIFont.CustomFont.bodyP4(text: descriptionText, textColor: .blackAC)
    }
}
