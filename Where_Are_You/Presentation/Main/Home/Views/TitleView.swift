//
//  TitleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/7/2024.
//

import UIKit
import Combine

class TitleView: UIView {
    private let viewModel: NotificationBadgeViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: NotificationBadgeViewModel = .shared) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

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
    
    private func setupObserver() {
        viewModel.$hasUnreadNotifications
            .receive(on: DispatchQueue.main)
            .sink { [weak self] hasUnread in
                self?.updateNotificationIcon(hasUnread: hasUnread)
            }
            .store(in: &cancellables)
    }
    
    private func updateNotificationIcon(hasUnread: Bool) {
        let imageName = hasUnread ? "icon-notification-badge" : "icon-notification"
        notificationButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
