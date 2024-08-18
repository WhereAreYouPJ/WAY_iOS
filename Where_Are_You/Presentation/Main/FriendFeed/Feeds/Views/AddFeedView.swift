//
//  AddFeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class AddFeedView: UIView {
    // MARK: - Properties

    let scheduleView = ScheduleDropDownView()
    
    let titleTextField = Utilities.textField(withPlaceholder: "제목", fontSize: 16)
    
    let titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    // TODO: 피드뷰에서 사용하는 콜렉션뷰 사용하기
    let imagesView = UICollectionView()
    
    let contentTextField = Utilities.textField(withPlaceholder: "어떤 일이 있었나요?", fontSize: 14)
    
    let addImages: UIView = {
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: "")
        let button = UIButton()
        view.addSubview(button)
        button.setTitle("사진 추가", for: .normal)
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        button.titleLabel?.textColor = .color102
        return view
    }()
    
    let membersInfo: UIView = {
        let view = UIView()
        return view
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func configureViewComponents() {
        
    }
    
    private func setupConstraints() {
        
    }
}
