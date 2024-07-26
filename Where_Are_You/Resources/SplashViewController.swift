//
//  SplashViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/7/2024.
//

import UIKit

class SplashViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkDeviceNetworkStatus()
        
    }
    
    func checkDeviceNetworkStatus() {
        
        if !(DeviceManager.shared.networkStatue) {
            let alert: UIAlertController = UIAlertController(title: "네트워크 상태 확인", message: "네트워크가 불안정 합니다.", preferredStyle: .alert)
            let action: UIAlertAction = UIAlertAction(title: "다시 시도", style: .default, handler: { (action) in
                self.checkDeviceNetworkStatus()
            })
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            guard let vc = self.storyboard?.instantiateViewController(identifier: "firstVC") else {
                print("ERROR")
                return
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true, completion: nil)
        }
        
    }
}
