//
//  AddFeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class AddFeedView: UIView {
    // MARK: - Properties

    let scheduleDropDownView = ScheduleDropDownView()
    
    let titleTextField = Utilities.textField(withPlaceholder: "제목", fontSize: 16)
    
    let titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    // TODO: 피드뷰에서 사용하는 콜렉션뷰 사용하기
    let imagesView: UIView = {
        let view = UIView()
        view.backgroundColor = .warningColor
        return view
    }()
    
    let contentTextField = Utilities.textField(withPlaceholder: "어떤 일이 있었나요?", fontSize: 14)
    
    lazy var feedStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleTextField, titleSeparator, imagesView, contentTextField])
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    
    // TODO: 버튼으로 변경하기
    let addImages: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        return view
    }()
    
    // TODO: 멤버 정보 받아오고 없으면 hidden하기
    let membersInfo: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
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
        addSubview(addImages)
        addSubview(membersInfo)
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
        }
        
        addStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTextField.snp.bottom).offset(LayoutAdapter.shared.scale(value: 28))
            make.leading.trailing.equalToSuperview()
        }
        
        addImages.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 46))
        }
    }
}
