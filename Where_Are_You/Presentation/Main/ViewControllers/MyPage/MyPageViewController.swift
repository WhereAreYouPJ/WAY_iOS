//
//  MyPageController.swift
//  Where_Are_You
//
//  Created by 오정석 on 24/7/2024.
//

import UIKit

class MyPageViewController: UIViewController {
    // MARK: - Properties
    
    private let myPageView = MyPageView()

    // MARK: - Lifecycle

    override func loadView() {
        view = myPageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
