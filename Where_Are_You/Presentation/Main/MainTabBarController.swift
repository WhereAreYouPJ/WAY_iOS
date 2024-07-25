//
//  MainTabBarController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit

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
        
        let mainVC = MainHomeViewController()
        mainVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: UIImage(named: "icon-home")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "icon-home-filled")?.withRenderingMode(.alwaysOriginal)
        )
        
        let scheduleVC = UIViewController() // 추후에 실제 컨트롤러로 변경
        scheduleVC.view.backgroundColor = .white
        scheduleVC.tabBarItem = UITabBarItem(
            title: "일정",
            image: UIImage(named: "icon-schedule")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "icon-schedule-filled")?.withRenderingMode(.alwaysOriginal)
        )
        
        let friendsVC = UIViewController() // 추후에 실제 컨트롤러로 변경
        friendsVC.view.backgroundColor = .white
        friendsVC.tabBarItem = UITabBarItem(
            title: "친구",
            image: UIImage(named: "icon-friends")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "icon-friends-filled")?.withRenderingMode(.alwaysOriginal)
        )
        
        let myPageVC = MyPageViewController() // 추후에 실제 컨트롤러로 변경
        myPageVC.tabBarItem = UITabBarItem(
            title: "마이페이지",
            image: UIImage(named: "icon-mypage")?.withRenderingMode(.alwaysOriginal),
            selectedImage: UIImage(named: "icon-mypage-filled")?.withRenderingMode(.alwaysOriginal)
        )
        
        viewControllers = [mainVC, scheduleVC, friendsVC, myPageVC]
        
        // 탭바 색상 (선택, 비선택)
        self.tabBar.tintColor = .color34
        self.tabBar.unselectedItemTintColor = .color34
        tabBar.backgroundColor = .white
        
        // 탭바의 분리선 추가
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        separator.backgroundColor = .brandColor
        tabBar.addSubview(separator)
    }
    
    // 탭바 높이
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var tabFrame = self.tabBar.frame
        tabFrame.size.height = tabbarHeight
        self.tabBar.frame = tabFrame
    }
}
