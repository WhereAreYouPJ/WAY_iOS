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
    
    private let segmentControl: UISegmentedControl = {
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

    private var showSearchBar: Bool = false {
        didSet {
            if let friendsHostingController = friendsHostingController {
                let updatedView = FriendsView(showSearchBar: .constant(showSearchBar))
                friendsHostingController.rootView = updatedView
            }
        }
    }
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
        stackView.distribution = .fillEqually
        return stackView
    }()
        
    private let friendOptionView: UIHostingController = {
        let view = OptionButtonView(inUIKit: true, content: {
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
        setupNavigationBar()
        setupUI()
        setupConstraints()
        setupActions()
        updateUIForSelectedSegment()
        setupNotificationObserver()
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        notificationBadgeViewModel.checkForNewNotifications() // 서버에서 알림 정보 가져오기
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = .white
        
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
                make.edges.equalToSuperview()
            }
        }
        
        friendsHostingController?.view.isHidden = true
        feedsViewController.view.isHidden = false
        view.bringSubviewToFront(feedsViewController.view)
        
        // Setup navigation items
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
        
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
    }
    
    private func setupConstraints() {
        feedsViewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        friendsHostingController?.view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 36)).priority(.required)
        }
        
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 34))
        }
        
        if segmentControl.selectedSegmentIndex == 0 {
//            view.addSubview(plusOptionButton)
//
//            plusOptionButton.snp.makeConstraints { make in
//                make.top.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 9))
//                make.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 15))
//                make.width.equalTo(160)
//                make.height.equalTo(38)
//            }
        }
        
        friendOptionView.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(0)
        }
    }
    
    private func setupActions() {
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        searchFriendButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
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
        if segmentControl.selectedSegmentIndex == 0 {
            view.bringSubviewToFront(feedsViewController.view)
            feedsViewController.view.isHidden = false
            friendsHostingController?.view.isHidden = true
            searchFriendButton.isHidden = true
            notificationButton.isHidden = false
            addButton.isHidden = false
            showSearchBar = false
            friendOptionView.view.isHidden = true
        } else {
            view.bringSubviewToFront(friendsHostingController!.view)
            feedsViewController.view.isHidden = true
            friendsHostingController?.view.isHidden = false
            searchFriendButton.isHidden = false
            notificationButton.isHidden = false
            addButton.isHidden = false
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
        if segmentControl.selectedSegmentIndex == 0 {
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
        notificationButton.setImage(UIImage(named: imageName), for: .normal)
    }
}
