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
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let scheduleDropDown = ScheduleDropDown()
    let titleTextField = Utilities.textField(withPlaceholder: "제목", fontSize: 16)
    let titleSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    let imageBackView = UIView()
    
    let imagesCollectionView: UICollectionView = {
        let layout = SnappingFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var imageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageBackView, imagesCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 0
        return stackView
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "어떤 일이 있었나요?"
        textView.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        textView.textColor = .color118
        return textView
    }()
    
    let addImages: UIButton = {
        let button = UIButton()
        let view = CustomView(image: "icon-Gallery", text: "사진 추가", textColor: .black66, separatorHidden: false)
        button.addSubview(view)
        view.isUserInteractionEnabled = false
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    let membersInfo = CustomView(image: "icon-users", text: "", textColor: .black22, separatorHidden: true)
    
    lazy var addStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [addImages, membersInfo])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let creatFeedButton = TitleButton(title: UIFont.CustomFont.button18(text: "게시하기", textColor: .white), backgroundColor: .brandMain, borderColor: nil)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
        imagesCollectionView.isHidden = true
        membersInfo.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleTextField)
        contentView.addSubview(titleSeparator)
        contentView.addSubview(imageStackView)
        contentView.addSubview(contentTextView)
        contentView.addSubview(addStackView)
        
        addSubview(creatFeedButton)
        contentView.addSubview(scheduleDropDown)

    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(creatFeedButton.snp.top)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        scheduleDropDown.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 13))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 77))
            make.leading.trailing.equalTo(scheduleDropDown)
        }
        
        titleSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        imageBackView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 7))
            make.top.leading.trailing.equalToSuperview()
        }
        
        imagesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 232))
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(titleSeparator.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 23))
            make.height.greaterThanOrEqualTo(LayoutAdapter.shared.scale(value: 110))
        }
        
        addStackView.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 28))
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addImages.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 46))
        }
        
        creatFeedButton.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
}
