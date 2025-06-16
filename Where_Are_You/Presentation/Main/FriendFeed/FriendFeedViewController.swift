//
//  FriendsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class FriendFeedViewController: UIViewController {
    // MARK: - Properties
    
    private var friendsHostingController: UIHostingController<FriendsView>?
    private let feedsViewController = FeedsViewController()
    private let notificationBadgeViewModel = NotificationBadgeViewModel.shared
    private var cancellables = Set<AnyCancellable>()
    
    private let titleView = FriendFeedTitleView()

    private var showSearchBar: Bool = false {
        didSet {
            if let friendsHostingController = friendsHostingController {
                let updatedView = FriendsView(showSearchBar: .constant(showSearchBar))
                friendsHostingController.rootView = updatedView
            }
        }
    }
        
    private let friendOptionView: UIHostingController = {
        let view = OptionButtonView(topPadding: 0, content: {
            OptionButton(
                title: "친구 추가",
                position: .top
            ) {
                NotificationCenter.default.post(name: .showAddFriend, object: nil)
            }
            
            OptionButton(
                title: "친구 관리",
                position: .bottom
            ) {
                NotificationCenter.default.post(name: .showManageFriends, object: nil)
            }
        })
        return UIHostingController(rootView: view)
    }()
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showAddFriendView),
            name: .showAddFriend,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showManageFriendsView),
            name: .showManageFriends,
            object: nil
        )
    }

    @objc private func showAddFriendView() {
        let addFriendView = AddFriendView()
            .navigationBarBackButtonHidden(true)
        let hostingController = UIHostingController(rootView: addFriendView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    @objc private func showManageFriendsView() {
        let manageFriendsView = ManageFriendsView()
            .navigationBarBackButtonHidden(true)
        let hostingController = UIHostingController(rootView: manageFriendsView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupUI()
        setupConstraints()
        setupActions()
        updateUIForSelectedSegment()
        setupNotificationObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
        notificationBadgeViewModel.checkForNewNotifications() // 서버에서 알림 정보 가져오기
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(titleView)
        
        // Add FeedsViewController
        addChild(feedsViewController)
        view.addSubview(feedsViewController.view)
        feedsViewController.didMove(toParent: self)

        let friendsView = FriendsView(showSearchBar: .constant(false))
        friendsHostingController = UIHostingController(rootView: friendsView)
        if let friendsHostingController = friendsHostingController {
            addChild(friendsHostingController)
            view.addSubview(friendsHostingController.view)
            friendsHostingController.didMove(toParent: self)
            friendsHostingController.view.isHidden = true
            
            friendsHostingController.view.snp.makeConstraints { make in
                make.top.equalTo(titleView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 7))
                make.leading.trailing.bottom.equalToSuperview()
            }
        }
        
        friendsHostingController?.view.isHidden = true
        feedsViewController.view.isHidden = false
        view.bringSubviewToFront(feedsViewController.view)
        
        view.addSubview(friendOptionView.view)
        
        friendOptionView.view.isHidden = true
        
        view.bringSubviewToFront(friendOptionView.view)
        
        // 친구 관리 메뉴
        addChild(friendOptionView)
        view.addSubview(friendOptionView.view)
        friendOptionView.didMove(toParent: self)
        friendOptionView.view.isHidden = true
        
        // 항상 최상단에 표시되도록
        view.bringSubviewToFront(friendOptionView.view)
        
        view.bringSubviewToFront(titleView)
    }
    
    private func setupConstraints() {
        titleView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
        
        feedsViewController.view.snp.makeConstraints { make in
            make.top.equalTo(titleView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 7))
            make.leading.trailing.bottom.equalToSuperview()
        }
        
//        friendsHostingController?.view.snp.makeConstraints { make in
//            make.top.equalTo(titleView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 7))
//            make.leading.trailing.bottom.equalToSuperview()
//        }
        
        friendOptionView.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(0)
        }
    }
    
    private func setupActions() {
        titleView.segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        titleView.searchFriendButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        titleView.notificationButton.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
        titleView.addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNotificationObserver() {
        // 사용자 정의 알림을 구독
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateNotificationIcon),
            name: .unreadNotificationsChanged,
            object: nil
        )
        
        updateNotificationIcon()
    }
    
    // MARK: - Helpers
    private func updateUIForSelectedSegment() {
        if titleView.segmentControl.selectedSegmentIndex == 0 {
            view.bringSubviewToFront(feedsViewController.view)
            feedsViewController.view.isHidden = false
            friendsHostingController?.view.isHidden = true
            titleView.searchFriendButton.isHidden = true
            titleView.notificationButton.isHidden = false
            titleView.addButton.isHidden = false
            showSearchBar = false
            friendOptionView.view.isHidden = true
        } else {
            view.bringSubviewToFront(friendsHostingController!.view)
            feedsViewController.view.isHidden = true
            friendsHostingController?.view.isHidden = false
            titleView.searchFriendButton.isHidden = false
            titleView.notificationButton.isHidden = false
            titleView.addButton.isHidden = false
        }
    }
    
    // MARK: - Actions
    @objc private func handleSegmentChange() {
        updateUIForSelectedSegment()
    }
    
    @objc private func handleSearch() {
        showSearchBar.toggle()
        print("친구 검색")
    }
    
    @objc private func handleNotification() {
        let notificationView = NotificationView()
        let hostingController = UIHostingController(rootView: notificationView)
        hostingController.modalPresentationStyle = .fullScreen
        present(hostingController, animated: true)
    }
    
    @objc private func handleAdd() {
        if titleView.segmentControl.selectedSegmentIndex == 0 {
            feedsViewController.plusOptionButton.isHidden = false
            friendOptionView.view.isHidden = true
//            plusOptionButton.isHidden = false
        } else {
             friendOptionView.view.isHidden.toggle()  // toggle로 변경
//            plusOptionButton.isHidden = false
            feedsViewController.plusOptionButton.isHidden = true
            // 최상단에 표시되도록 추가
            if !friendOptionView.view.isHidden {
                view.bringSubviewToFront(friendOptionView.view)
            }
        }
    }
    
    @objc private func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !friendOptionView.view.frame.contains(location) {
            friendOptionView.view.isHidden = true
        }
    }
    
    @objc private func updateNotificationIcon() {
        // 읽지 않은 알림이 있는지 확인
        let imageName = notificationBadgeViewModel.hasUnreadNotifications ? "icon-notification-badge" : "icon-notification"
        titleView.notificationButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
