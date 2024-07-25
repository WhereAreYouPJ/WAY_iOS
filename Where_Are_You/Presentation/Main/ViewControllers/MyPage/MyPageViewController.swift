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
        myPageView.setButtonActions(target: self, action: #selector(buttonTapped(_:)))
        myPageView.imageEditButton.addTarget(self, action: #selector(editImage), for: <#T##UIControl.Event#>)
        myPageView.userNameEditButton.addTarget(self, action: #selector(editUserName), for: <#T##UIControl.Event#>)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
            switch sender.tag {
            case 0:
                // Handle "내 정보 관리"
                print("내 정보 관리 tapped")
            case 1:
                // Handle "위치 즐겨찾기"
                print("위치 즐겨찾기 tapped")
            case 2:
                // Handle "피드 책갈피"
                print("피드 책갈피 tapped")
            case 3:
                // Handle "피드 보관함"
                print("피드 보관함 tapped")
            case 4:
                // Handle "공지사항"
                print("공지사항 tapped")
            case 5:
                // Handle "1:1 이용문의"
                print("1:1 이용문의 tapped")
            default:
                break
            }
        }
    
    @objc private func editImage() {
        
    }
    
    @objc private func editUserName() {
        
    }
}
