//
//  LoginAuth.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class LoginView: UIView {
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        let attrString = NSAttributedString(
//            string: "지금 어디?",
//            attributes: [
//                NSAttributedString.Key.foregroundColor: UIColor.mainPurple,
//                NSAttributedString.Key.font: UIFont.pretendard(size: 36, weight: .bold),
//                NSAttributedString.Key.strokeWidth: -0.3
//            ]
//        )
//        
//        label.attributedText = attrString
        label.font = UIFont.pretendard(size: 36, weight: .bold)
        label.text = "지금 어디?"
        label.textColor = UIColor.mainPurple
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkfont()
        addSubview(titleLabel)
        titleLabel.centerX(inView: self, topAnchor: topAnchor, paddingTop: 150)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 폰트 이름 체크
    func checkfont() {
        for family in UIFont.familyNames {
            print("family: \(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print(name)
            }
        }
    }
    
}
