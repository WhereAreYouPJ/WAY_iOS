//
//  SceneDelegate.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/5/2024.
//

import UIKit
import SwiftUI
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var toastHostingController: UIHostingController<ToastOverlayView>?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }
//        
//        let vc = SplashViewController()
//        let navController = UINavigationController(rootViewController: vc)
//            
//        window = UIWindow(windowScene: scene)
//        window?.rootViewController = navController
//        window?.makeKeyAndVisible()
        
        let splashVC = SplashViewController()
            
            window = UIWindow(windowScene: scene)
            window?.rootViewController = splashVC
            window?.backgroundColor = UIColor.rgb(red: 123, green: 80, blue: 255)  // 💡 윈도우 배경도 맞춰서 설정
            window?.makeKeyAndVisible()
        // ToastManager 초기화 (이렇게 하면 싱글톤 인스턴스가 생성됨)
        _ = ToastManager.shared
    }
    
    // Kakao 로그인 이후 앱으로 돌아올 url 설정
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        NotificationBadgeViewModel.shared.checkForNewNotifications() // 알림 상태 서버와 동기화
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}
