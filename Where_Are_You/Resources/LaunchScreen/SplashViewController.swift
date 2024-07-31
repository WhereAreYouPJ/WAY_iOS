//
//  SplashViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/7/2024.
//

import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brandColor
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
            let vc = LoginViewController()
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
