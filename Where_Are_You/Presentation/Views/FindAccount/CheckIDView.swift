//
//  CheckIDView.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/6/2024.
//

import UIKit
import SnapKit

class CheckIDView: UIView {
    // MARK: - Properties
    
    let titleLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .bold, text: "회원님의 아이디를 확인해주세요", textColor: .color34, fontSize: 22)
    
    let idLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "회원님의 아이디는", textColor: .color34, fontSize: 14)
    
    let idDescriptionLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .bold, text: "", textColor: .letterBrandColor, fontSize: 18)
        
    let idLabel2 = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "입니다.", textColor: .color34, fontSize: 14)
    
    let separatorView = UIView()
    
    let descriptionLabel = Utilities().inputContainerLabel(UILabel_NotoSans: .medium, text: "로그인 또는 비밀번호 찾기 버튼을 눌러주세요.", textColor: .color102, fontSize: 14)
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    func setupTitle() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(34)
            make.left.equalToSuperview().offset(15)
            make.width.equalToSuperview().multipliedBy(0.48)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
