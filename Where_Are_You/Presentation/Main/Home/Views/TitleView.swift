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
        setupUI()
        setupObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleLabel: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo-long")
        return imageView
    }()
    
    let notificationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-notification"), for: .normal)
        return button
    }()
    
    private func setupObserver() {
        NotificationCenter.default.publisher(for: .unreadNotificationsChanged) // NotificationCenter를 사용하여 알림 상태 변경 구독
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if let hasUnread = notification.userInfo?["hasUnread"] as? Bool {
                    self?.updateNotificationIcon(hasUnread: hasUnread)
                }
            }
            .store(in: &cancellables)
        
        updateNotificationIcon(hasUnread: viewModel.hasUnreadNotifications) // 초기 상태 설정
    }
    
    private func updateNotificationIcon(hasUnread: Bool) {
        let imageName = hasUnread ? "icon-notification-badge" : "icon-notification"
        notificationButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func setupUI() {
        addSubview(titleLabel)
        addSubview(notificationButton)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.leading.equalToSuperview()
//            make.height.equalTo(LayoutAdapter.shared.scale(value: 26))
            make.height.equalTo(26)
            make.width.equalTo(132)
//            make.width.equalTo(LayoutAdapter.shared.scale(value: 132))
        }
        
        notificationButton.snp.makeConstraints { make in
//            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 24))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 13))
            make.trailing.equalToSuperview()
        }
    }
}
