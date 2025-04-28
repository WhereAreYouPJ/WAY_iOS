//
//  AppDelegate.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/5/2024.
//

import UIKit
import CoreData
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoMapsSDK
import Kingfisher
import Firebase
import FirebaseMessaging
import AVFoundation
import IQKeyboardManager

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SDKInitializer.InitSDK(appKey: Config.kakaoAppKey)
        KakaoSDK.initSDK(appKey: Config.kakaoAppKey)
        
        // 초기화 완료를 추적하는 지연 호출 추가
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            KakaoMapInitializer.shared.initializeSDK {
//                print("📍 카카오맵 SDK 초기화 완료 콜백")
//            }
//        }
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // FCM 델리게이트 설정 추가
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        registerForPushNotifications()
        application.registerForRemoteNotifications()
        
        // 네비게이션 바 스타일 설정 추가
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true

        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // 앱 종료 시 캐시 데이터 정리
        ImageCache.default.cleanExpiredDiskCache()
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Kakao Login
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Where_Are_You")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

// MARK: - Kakao Map
class KakaoMapInitializer {
    static let shared = KakaoMapInitializer()
    private(set) var isInitialized = false
    private var pendingCompletions: [() -> Void] = []
    
    func initializeSDK(completion: @escaping () -> Void) {
        if isInitialized {
            completion()
            return
        }
        
        pendingCompletions.append(completion)
        
        // 이미 초기화 시도 중이면 중복 시도 방지
        guard pendingCompletions.count == 1 else { return }
        
        print("📍 카카오맵 SDK 초기화 시작")
        
        // SDK는 이미 AppDelegate에서 초기화됨
        // 여기서는 초기화 완료 상태를 관리
        
        // 2초 후에 초기화 완료로 간주
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            guard let self = self else { return }
            self.isInitialized = true
            print("📍 카카오맵 SDK 초기화 완료")
            
            // 대기 중인 모든 완료 핸들러 호출
            for completion in self.pendingCompletions {
                completion()
            }
            self.pendingCompletions.removeAll()
        }
    }
}

extension AppDelegate {
    private func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("##### Permission granted: \(granted)")
                // 추가
                guard granted else { return }
                self.getNotificationSettings()
            }
        
    }
    
    private func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("##### Notification settings: \(settings)")
        }
    }
}

// MARK: UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        print("🔐didRegisterForRemoteNotificationsWithDeviceToken deviceToken : \(deviceToken)")
        let token = deviceToken.reduce("") {
            $0 + String(format: "%02X", $1)
        }
        print("🔐didRegisterForRemoteNotificationsWithDeviceToken deviceToken : \(token)")
        
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // fcm 토큰 받지 못했을 때의 예외 처리
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error)")
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        print("🔐userNotificationCenter willPresent : \(userInfo)")
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("Failed to set badge count: \(error)")
            }
        }
        
        completionHandler([.banner, .badge, .sound])
    }
    
    //    Function that the app is called while background or not running
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("Failed to set badge count: \(error)")
            }
        }
        
        let userInfo = response.notification.request.content.userInfo
        print("🔐userNotificationCenter didReceive : \(userInfo)")
        
        completionHandler()
    }
}

// MARK: MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("🔐Firebase registration token: \(String(describing: fcmToken))")
        
        if let token = fcmToken {
            UserDefaultsManager.shared.saveFcmToken(token)
        }
        print("🔐FCM Token : \(UserDefaultsManager.shared.getFcmToken())")
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingDelegate) {
        print("🔐Received data message: \(remoteMessage.description)")
    }
}
