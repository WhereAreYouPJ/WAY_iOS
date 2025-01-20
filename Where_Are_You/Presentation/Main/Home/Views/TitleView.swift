//
//  TitleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/7/2024.
//

import UIKit

class TitleView: UIView {
    // MARK: - Properties

    let titleLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-long")
        imageView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 26))
            make.width.equalTo(LayoutAdapter.shared.scale(value: 132))
        }
        return imageView
    }()
    
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-notification"), for: .normal)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 34))
        }
        return button
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.snp.makeConstraints { make in
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 34))
        }
        button.setImage(UIImage(named: "icon-mypage"), for: .normal)
        return button
    }()
    
    lazy var iconStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [notificationButton, profileButton])
        stackView.axis = .horizontal
        return stackView
    }()
}
