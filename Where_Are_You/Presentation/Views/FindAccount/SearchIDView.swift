//
//  SearchID.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/5/2024.
//

import UIKit
import SnapKit

class SearchIDView: UIView {
    // MARK: - Properties
    
    let titleLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .bold, text: "지금어디 가입 정보로 아이디를 확인하세요", textColor: .color34, fontSize: 22)
    
    let emailLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "이메일 주소", textColor: .color51, fontSize: 12)
    
    let emailTextField = Utilities().inputContainerTextField(withPlaceholder: "이메일", fontSize: 14)
    
    let requestAuthButton = CustomButton(title: "인증요청", backgroundColor: .brancColor, titleColor: .white, font: UIFont.pretendard(NotoSans: .medium, fontSize: 14))
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
