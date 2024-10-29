////
////  CustomAlertViewController.swift
////  Where_Are_You
////
////  Created by juhee on 23.10.24.
////
//
//import UIKit
//import SwiftUI
//
//class CustomAlertViewController: UIViewController {
//    private var alertView: CustomAlertSwiftUI
//    
//    init(alertView: CustomAlertSwiftUI) {
//        self.alertView = alertView
//        super.init(nibName: nil, bundle: nil)
//        self.modalPresentationStyle = .overFullScreen
//        self.modalTransitionStyle = .crossDissolve
//        self.view.backgroundColor = .clear
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        let hostingController = UIHostingController(rootView: alertView)
//        hostingController.view.backgroundColor = .clear
//        
//        addChild(hostingController)
//        view.addSubview(hostingController.view)
//        hostingController.view.frame = view.bounds
//        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        hostingController.didMove(toParent: self)
//    }
//}
//
//extension View {
//    func customAlert(isPresented: Binding<Bool>,
//                    showDailySchedule: Binding<Bool>,
//                    title: String,
//                    message: String,
//                    cancelTitle: String,
//                    actionTitle: String,
//                    action: @escaping () -> Void) -> some View {
//        return self.onChange(of: isPresented.wrappedValue) { newValue in
//            if newValue {
//                let alertView = CustomAlertSwiftUI(
//                    isPresented: isPresented,
//                    showDailySchedule: showDailySchedule,
//                    title: title,
//                    message: message,
//                    cancelTitle: cancelTitle,
//                    actionTitle: actionTitle,
//                    action: action
//                )
//                
//                let alertViewController = CustomAlertViewController(alertView: alertView)
//                
//                // MainTabBarController를 찾아서 알림을 표시
//                DispatchQueue.main.async {
//                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                       let window = windowScene.windows.first,
//                       let tabBarController = window.rootViewController?.children.first(where: { $0 is MainTabBarController }) {
//                        tabBarController.present(alertViewController, animated: true)
//                    }
//                }
//            }
//        }
//    }
//}
