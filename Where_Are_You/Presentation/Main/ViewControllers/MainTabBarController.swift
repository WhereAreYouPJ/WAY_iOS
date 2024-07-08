//
//  MainTabBarController.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/7/2024.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController {
    
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
    
    // TODO: 컨트롤러 변경하기
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = MainHomeViewController()
        mainVC.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
        
        let scheduleVC = UIViewController() // 추후에 실제 컨트롤러로 변경
        scheduleVC.view.backgroundColor = .white
        scheduleVC.tabBarItem = UITabBarItem(title: "일정", image: UIImage(systemName: "calendar"), tag: 1)
        
        let friendsVC = UIViewController() // 추후에 실제 컨트롤러로 변경
        friendsVC.view.backgroundColor = .white
        friendsVC.tabBarItem = UITabBarItem(title: "친구", image: UIImage(systemName: "person.2"), tag: 2)
        
        let myPageVC = UIViewController() // 추후에 실제 컨트롤러로 변경
        myPageVC.view.backgroundColor = .white
        myPageVC.tabBarItem = UITabBarItem(title: "마이페이지", image: UIImage(systemName: "person"), tag: 3)
        
        viewControllers = [mainVC, scheduleVC, friendsVC, myPageVC]
        
    }
}
