//
//  AddFeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit
import SnapKit

class AddFeedView: UIView {
    // MARK: - Properties
    
    let scheduleDropDownView = ScheduleDropDownView()
    
    let titleTextField = Utilities.textField(withPlaceholder: "제목", fontSize: 16)
    
    lazy var titleSeparator = createSeparator()
    
    // TODO: 피드뷰에서 사용하는 콜렉션뷰 사용하기
    let imagesView: UIView = {
        let view = UIView()
        view.backgroundColor = .warningColor
        return view
    }()
    
    // TODO: TextView로 바꿔야함
    let contentTextField = Utilities.textField(withPlaceholder: "어떤 일이 있었나요?", fontSize: 14)
    
    let addImages: UIButton = {
        let button = UIButton()
        let view = CustomView(image: "icon-Gallery", text: "사진 추가", textColor: .color102, separatorHidden: false)
        button.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    let membersInfo = CustomView(image: "icon-users", text: "김민정, 임창균, 이주헌 외 4명", textColor: .color34, separatorHidden: true)
    
    lazy var addStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addImages, membersInfo])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
        imagesView.isHidden = true
        membersInfo.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(scheduleDropDownView)
        addSubview(titleTextField)
        addSubview(titleSeparator)
        addSubview(imagesView)
        addSubview(contentTextField)
        addSubview(addStackView)
    }
    
    private func setupConstraints() {
        scheduleDropDownView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 13))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 77))
            make.leading.trailing.equalTo(scheduleDropDownView)
        }
        
        titleSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.leading.trailing.equalTo(scheduleDropDownView)
            make.height.equalTo(1)
        }
        
        imagesView.snp.makeConstraints { make in
            make.top.equalTo(titleSeparator.snp.bottom).offset(LayoutAdapter.shared.scale(value: 7))
            make.leading.trailing.equalToSuperview()
        }
        
        contentTextField.snp.makeConstraints { make in
            make.top.equalTo(imagesView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 7))
            make.leading.trailing.equalTo(scheduleDropDownView)
            make.height.greaterThanOrEqualTo(LayoutAdapter.shared.scale(value: 110))
        }
        
        addStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTextField.snp.bottom).offset(LayoutAdapter.shared.scale(value: 28))
            make.leading.trailing.equalToSuperview()
        }
        
        addImages.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 46))
        }
    }
    
    func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .color221
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
}
