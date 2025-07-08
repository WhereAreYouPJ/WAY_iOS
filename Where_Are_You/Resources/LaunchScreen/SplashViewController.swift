//
//  SplashViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/7/2024.
//

import UIKit
import SwiftUI

class SplashViewController: UIViewController {
    private var viewModel: SplashViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBindings()
        view.backgroundColor = UIColor.rgb(red: 123, green: 80, blue: 255)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkDeviceNetworkStatus()
    }
    
    private func setupViewModel() {
        let adminService = AdminService()
        let adminRepository = AdminRepository(adminService: adminService)
        viewModel = SplashViewModel(getServerStatusUseCase: GetServerStatusUseCaseImpl(adminRepository: adminRepository))
    }
    
    private func setupBindings() {
        viewModel.onServerStatus = { [weak self] serverStatus in
            print("serverStatus is \(serverStatus)")
            DispatchQueue.main.async {
            if serverStatus {
                self?.navigateBasedOnLoginStatus()
            } else {
                    let networkAlert = NetworkAlert(action: {
                        self?.viewModel.checkServerHealth()
                    }, serverIssue: true)
                    networkAlert.showAlert(on: self!)
                }
            }
        }
    }
    
    func checkDeviceNetworkStatus() {
        if !(DeviceManager.shared.networkStatue) {
            DispatchQueue.main.async {
                let networkAlert = NetworkAlert(action: {
                    self.checkDeviceNetworkStatus()
                }, serverIssue: false)
                networkAlert.showAlert(on: self)
            }
        } else {
            checkServerHealth()
        }
    }
    
    func checkServerHealth() {
        viewModel.checkServerHealth()
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
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate,
              let window = sceneDelegate.window else {
            return
        }

        let nav = UINavigationController(rootViewController: viewController) // Navigation 포함
        window.rootViewController = nav
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil)
        window.makeKeyAndVisible()
    }
}
