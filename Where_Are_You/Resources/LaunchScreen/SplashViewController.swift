//
//  SplashViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/7/2024.
//

import UIKit
import SwiftUI

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 123, green: 80, blue: 255)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkDeviceNetworkStatus()
    }
    
    func checkDeviceNetworkStatus() {
        if !(DeviceManager.shared.networkStatue) {
            let networkAlert = NetworkAlert(action: {
                self.checkDeviceNetworkStatus()
            })
            networkAlert.showAlert(on: self)
        } else {
            navigateBasedOnLoginStatus()
        }
    }
    
    private func navigateBasedOnLoginStatus() {
        if UserDefaultsManager.shared.getIsLoggedIn() {
            let mainTabBarController = MainTabBarController()
            transitionToViewController(mainTabBarController)
        } else {
            let loginVC = LoginViewController()
            transitionToViewController(loginVC)
        }
    }
    
    private func transitionToViewController(_ viewController: UIViewController) {
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
