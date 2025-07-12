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
        textView.text = "어떤 하루를 보냈나요?"
        textView.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        textView.textColor = .color118
        return textView
    }()
    
    let membersInfo = CustomView(image: "user1", text: "", textColor: .black22, separatorHidden: true, imageTintColor: .black)
    
    let addImages: UIButton = {
        let button = UIButton()
        let view = CustomView(image: "icon-feedGallery", text: "사진 추가", textColor: .black66, separatorHidden: false, imageTintColor: .black66)
        button.addSubview(view)
        view.isUserInteractionEnabled = false
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return button
    }()
    
    lazy var addStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [membersInfo, addImages])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let creatFeedButton = TitleButton(title: UIFont.CustomFont.button18(text: "업로드하기", textColor: .white), backgroundColor: .blackAC, borderColor: nil)
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
        creatFeedButton.isEnabled = true
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
        contentView.addSubview(imageStackView)
        contentView.addSubview(contentTextView)
        
        addSubview(titleTextField)
        addSubview(titleSeparator)

        addSubview(addStackView)
        addSubview(creatFeedButton)
        
        addSubview(scheduleDropDown)
    }
    
    private func setupConstraints() {
        scheduleDropDown.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 86))
            make.leading.trailing.equalTo(scheduleDropDown)
        }
        
        titleSeparator.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(LayoutAdapter.shared.scale(value: 8))
            make.height.equalTo(1)
            make.leading.trailing.equalTo(scheduleDropDown)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(titleSeparator.snp.bottom).offset(LayoutAdapter.shared.scale(value: 3))
            make.bottom.equalTo(addStackView.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 356))
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        imageBackView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 7))
            make.top.leading.trailing.equalToSuperview()
        }
        
        imagesCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 246))
        }
        
        imageStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(imageStackView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalToSuperview()
        }
        
        addStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.trailing.equalToSuperview()
        }
        
        addImages.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 46))
        }
        
        creatFeedButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24))
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(LayoutAdapter.shared.scale(value: 24))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 48))
        }
    }
}
