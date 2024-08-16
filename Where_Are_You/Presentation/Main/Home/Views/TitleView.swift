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
        imageView.image = UIImage(named: "Home-Logo")
        return imageView
    }()
    
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-notification"), for: .normal)
        return button
    }()
    
    let profileButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-mypage"), for: .normal)
        return button
    }()
    
    lazy var iconStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [notificationButton, profileButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
}
