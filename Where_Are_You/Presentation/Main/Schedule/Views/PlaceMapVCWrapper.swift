//
//  PlaceMapVCWrapper.swift
//  Where_Are_You
//
//  Created by juhee on 23.08.24.
//

import Foundation
import SwiftUI
import KakaoMapsSDK

//struct PlaceMapVCWrapper: UIViewControllerRepresentable {
//    func makeUIViewController(context: Context) -> some UIViewController {
//        
//    }
//    
//    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
//        
//    }
//}

class PlaceMapViewController: UIViewController {
    override func viewDidLoad() {
        SDKInitializer.InitSDK(appKey: Config.kakaoAppKey)
        self.viewDidLoad()
    }
}
