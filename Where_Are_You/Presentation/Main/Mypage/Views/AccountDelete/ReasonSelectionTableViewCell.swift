//
//  ReasonSelectionTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import UIKit
import SnapKit

class ReasonSelectionTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ReasonSelectionTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.color221.cgColor
        view.backgroundColor = .white
        return view
    }()
    
    private let checkmarkView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "circle")
        imageView.tintColor = .color217
        imageView.snp.makeConstraints { make in
            make.width.equalTo(LayoutAdapter.shared.scale(value: 22))
        }
        return imageView
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .black22
        return label
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 6
        tv.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        tv.textColor = .black22
        tv.backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 내부 여백
        tv.isHidden = true
        tv.isScrollEnabled = false
        return tv
    }()
    
    private lazy var titleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [checkmarkView, reasonLabel])
        sv.axis = .horizontal
        sv.spacing = LayoutAdapter.shared.scale(value: 10)
        return sv
    }()
    
    private lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleStackView, textView])
        sv.axis = .vertical
        sv.spacing = LayoutAdapter.shared.scale(value: 10)
        return sv
    }()
    
    var onTextChange: ((String) -> Void)?
    private let placeholderText = "기타(직접입력)" // Placeholder 텍스트

    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupConstraints()
        textView.delegate = self // Delegate 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        stackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        textView.snp.makeConstraints { make in
            make.width.equalTo(LayoutAdapter.shared.scale(value: 305))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 140))
        }
    }
    
    func configure(reason: String, isSelected: Bool, isTextFieldVisible: Bool) {
        reasonLabel.text = reason
        checkmarkView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkmarkView.tintColor = isSelected ? .brandColor : .color217
        textView.isHidden = !isTextFieldVisible
        textView.text = reason
    }
}

// MARK: - UITextViewDelegate
extension ReasonSelectionTableViewCell: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholderText {
            // Placeholder 제거
            textView.text = ""
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            // Placeholder 활성화
            textView.text = placeholderText
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        onTextChange?(textView.text) // 텍스트 변경 이벤트 전달
    }
}
