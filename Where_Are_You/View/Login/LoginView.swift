//
//  LoginAuth.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit
import SnapKit

class LoginView: UIView {
    // MARK: - Properties
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(size: 36, weight: .bold)
        label.text = "지금 어디?"
        label.textColor = UIColor.letterBrandColor
        return label
    }()
    
    let subtitleLabel: UILabel = {
       let label = UILabel()
        label.text = "위치기반 일정관리 플랫폼"
        label.font = UIFont(name: "Noto Sans KR", size: 14)
        label.textColor = UIColor.rgb(red: 68, green: 68, blue: 68)
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
