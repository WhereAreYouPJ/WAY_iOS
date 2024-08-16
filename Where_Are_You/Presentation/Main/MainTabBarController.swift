//
//  MainTabBarController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit
import SwiftUI

class MainTabBarController: UITabBarController {
    
    // 탭바 height 커스터 마이징
    let tabbarHeight: CGFloat = 100
    
    // 로그인 했는지 안했는지 확인
    func authenticatieUserAndConfigureUI() {
        if UserDefaults.standard.isLoggedIn == false {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            // 로그인 화면
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 각 뷰 컨트롤러를 초기화하고 설정
        let mainVC = createNavController(viewController: MainHomeViewController(), title: "홈", imageName: "icon-home", selectedImageName: "icon-home-filled")
        let scheduleVC = createNavController(viewController: UIHostingController(rootView: ScheduleView()), title: "일정", imageName: "icon-schedule", selectedImageName: "icon-schedule-filled")
        let friendsVC = createNavController(viewController: FriendFeedViewController(), title: "친구", imageName: "icon-friends", selectedImageName: "icon-friends-filled")
        let myPageVC = createNavController(viewController: MyPageViewController(), title: "마이페이지", imageName: "icon-mypage", selectedImageName: "icon-mypage-filled")
        
        // 탭바 컨트롤러에 뷰 컨트롤러 추가
        viewControllers = [mainVC, scheduleVC, friendsVC, myPageVC]
        
        // 탭바 색상 (선택, 비선택)
        self.tabBar.tintColor = .color34
        self.tabBar.unselectedItemTintColor = .color34
        tabBar.backgroundColor = .white
        
        navigationController?.navigationBar.isHidden = true
        // 탭바의 분리선 추가
        addTabBarSeparator()
    }
    
    // 탭바 높이
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = tabbarHeight
        self.tabBar.frame = tabFrame
    }
    
    // 뷰 컨트롤러를 네비게이션 컨트롤러로 감싸고 탭바 아이템을 설정하는 함수
    private func createNavController(viewController: UIViewController, title: String, imageName: String, selectedImageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: viewController)
        let tabBarItem = UITabBarItem(
            title: title,
            image: UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: selectedImageName)?.withRenderingMode(.alwaysOriginal)
        )
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10) // 타이틀을 아래로 이동
        tabBarItem.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: -5, right: 0) // 이미지를 위로 이동
        viewController.tabBarItem = tabBarItem
        return navController
    }
    
    // 탭바에 분리선 추가하는 함수
    private func addTabBarSeparator() {
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        separator.backgroundColor = .brandColor
        tabBar.addSubview(separator)
    }
}
