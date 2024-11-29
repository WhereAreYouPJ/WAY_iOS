//
//  FriendsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import Foundation
import UIKit
import SwiftUI

class FriendFeedViewController: UIViewController {
    // MARK: - Properties
    private var friendsHostingController: UIHostingController<FriendsView>?
    private let feedsViewController = FeedsViewController()
    
    private let segmentControl: UISegmentedControl = {
        let sc = UISegmentedControl()
        sc.insertSegment(withTitle: "피드", at: 0, animated: true)
        sc.insertSegment(withTitle: "친구", at: 1, animated: true)
        sc.selectedSegmentIndex = 0
        
        sc.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.color102,
            NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 20)
        ], for: .normal)
        sc.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.color34,
            NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 20)
        ], for: .selected)
        
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
    
    let plusOptionButton = CustomOptionButtonView(title: "새 피드 작성")
    
    // MARK: - 친구 탭 옵션메뉴
    private let friendOptionView: UIHostingController = {
        let view = MultiOptionButtonView {
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
        }
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
        
        // plusOptionButton과 friendOptionView를 항상 view에 추가
        view.addSubview(plusOptionButton)
        view.addSubview(friendOptionView.view)
        
        plusOptionButton.isHidden = true
        friendOptionView.view.isHidden = true
        
        view.bringSubviewToFront(plusOptionButton)
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
            view.addSubview(plusOptionButton)
            
            plusOptionButton.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 9))
                make.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 15))
                make.width.equalTo(160)
                make.height.equalTo(38)
            }
        }
        
        friendOptionView.view.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 9))
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(LayoutAdapter.shared.scale(value: 15))
        }
    }
    
    private func setupActions() {
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
        searchFriendButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
        plusOptionButton.button.addTarget(self, action: #selector(plusOptionButtonTapped), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
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
            plusOptionButton.isHidden = true
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
        print("알림 페이지로 이동")
    }
    
    @objc private func handleAdd() {
        if segmentControl.selectedSegmentIndex == 0 {
            plusOptionButton.isHidden = false
            friendOptionView.view.isHidden = true
            view.bringSubviewToFront(plusOptionButton)
        } else {
            friendOptionView.view.isHidden = false
            plusOptionButton.isHidden = true
            view.bringSubviewToFront(friendOptionView.view)
        }
    }
    
    @objc func plusOptionButtonTapped() {
        let controller = AddFeedViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func handleOutsideTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !plusOptionButton.frame.contains(location) {
            plusOptionButton.isHidden = true
        }
        if !friendOptionView.view.frame.contains(location) {
            friendOptionView.view.isHidden = true
        }
    }
}

//class FriendFeedViewController: UIViewController {
//    // MARK: - Properties
//    //    private let friendsViewController = FriendsListViewController()
//    private var friendsHostingController: UIHostingController<FriendsView>?
//    private let feedsViewController = FeedsViewController()
//
//    let friend: UIImage = {
//        let image = UIImage()
//        return image
//    }()
//
//    let feed: UIImage = {
//        let image = UIImage()
//        return image
//    }()
//
//    private let segmentControl: UISegmentedControl = {
//        let sc = UISegmentedControl()
//        sc.insertSegment(withTitle: "피드", at: 0, animated: true)
//        sc.insertSegment(withTitle: "친구", at: 1, animated: true)
//        sc.selectedSegmentIndex = 0
//
//        sc.setTitleTextAttributes([
//            NSAttributedString.Key.foregroundColor: UIColor.color102,
//            NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 20)
//        ], for: .normal)
//        sc.setTitleTextAttributes([
//            NSAttributedString.Key.foregroundColor: UIColor.color34,
//            NSAttributedString.Key.font: UIFont.pretendard(NotoSans: .medium, fontSize: 20)
//        ], for: .selected)
//
//        sc.selectedSegmentTintColor = .clear
//        sc.backgroundColor = .clear
//        let image = UIImage()
//        sc.setBackgroundImage(image, for: .normal, barMetrics: .default)
//        sc.setDividerImage(image, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
//        return sc
//    }()
//
//    let searchFriendButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-search"), for: .normal)
//        button.tintColor = .brandColor
//        return button
//    }()
//
//    let notificationButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-notification"), for: .normal)
//        button.tintColor = .brandColor
//        return button
//    }()
//
//    let addButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "icon-plus"), for: .normal)
//        button.snp.makeConstraints { make in
//            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 34))
//        }
//        button.tintColor = .brandColor
//        return button
//    }()
//
//    private lazy var barButtonStack: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [searchFriendButton, notificationButton, addButton])
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
//
//    // MARK: - Lifecycle
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupNavigationBar()
//        setupViews()
//        showFeedsView()
//        handleSegmentChange()
//        buttonActions()
//
//        segmentControl.snp.makeConstraints { make in
//            make.height.equalTo(LayoutAdapter.shared.scale(value: 36)).priority(.required)
//        }
//    }
//
//    // MARK: - Helpers
//
//    private func setupNavigationBar() {
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: segmentControl)
//        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: barButtonStack)
//        segmentControl.addTarget(self, action: #selector(handleSegmentChange), for: .valueChanged)
//    }
//
//    private func setupViews() {
//        view.backgroundColor = .white
//
//        addChild(feedsViewController)
//        view.addSubview(feedsViewController.view)
//        feedsViewController.didMove(toParent: self)
//
//        feedsViewController.view.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(8)
//            make.leading.trailing.bottom.equalToSuperview()
//        }
//
//        // SwiftUI FriendsView를 UIHostingController로 래핑
//        let friendsView = FriendsView()
//        friendsHostingController = UIHostingController(rootView: friendsView)
//
//        if let friendsHostingController = friendsHostingController {
//            addChild(friendsHostingController)
//            view.addSubview(friendsHostingController.view)
//            friendsHostingController.didMove(toParent: self)
//
//            friendsHostingController.view.snp.makeConstraints { make in
//                make.top.equalToSuperview().inset(15)
//                make.leading.trailing.bottom.equalToSuperview()
//            }
//
//            friendsHostingController.view.isHidden = true
//        }
//    }
//
//    private func buttonActions() {
//        searchFriendButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
//        notificationButton.addTarget(self, action: #selector(handleNotification), for: .touchUpInside)
//        addButton.addTarget(self, action: #selector(handleAdd), for: .touchUpInside)
//    }
//
//    private func showFriendsView() {
//        friendsHostingController?.view.isHidden = false
//        feedsViewController.view.isHidden = true
//        searchFriendButton.isHidden = false
//        notificationButton.isHidden = false
//        addButton.isHidden = false
//    }
//
//    private func showFeedsView() {
//        friendsHostingController?.view.isHidden = false
//        feedsViewController.view.isHidden = false
//        searchFriendButton.isHidden = true
//        notificationButton.isHidden = false
//        addButton.isHidden = false
//    }
//
//    // MARK: - Selectors
//
//    @objc private func handleSegmentChange() {
//        if segmentControl.selectedSegmentIndex == 0 {
//            showFeedsView()
//        } else {
//            showFriendsView()
//        }
//    }
//
//    @objc private func handleSearch() {
//        print("친구 검색")
//    }
//
//    @objc private func handleNotification() {
//        print("알림 페이지로 이동")
//    }
//
//    @objc private func handleAdd() {
//        // 피드
//        if segmentControl.selectedSegmentIndex == 0 {
//            let controller = AddFeedViewController()
//            let nav = UINavigationController(rootViewController: controller)
//            nav.modalPresentationStyle = .fullScreen
//            present(nav, animated: true, completion: nil)
//        } else {
//            print("친구 추가 버튼 눌림")
//        }
//    }
//}
