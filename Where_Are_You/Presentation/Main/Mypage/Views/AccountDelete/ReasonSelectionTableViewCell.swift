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
        return imageView
    }()
    
    private let reasonLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .color34
        return label
    }()
    
    private let textView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = 6
        tv.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        tv.textColor = .color34
        tv.backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
        tv.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) // 내부 여백
        tv.isHidden = true
        tv.isScrollEnabled = false
        return tv
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
        containerView.addSubview(checkmarkView)
        containerView.addSubview(reasonLabel)
        containerView.addSubview(textView)
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
        
        checkmarkView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
        }
        
        reasonLabel.snp.makeConstraints { make in
            make.centerY.equalTo(checkmarkView)
            make.leading.equalTo(checkmarkView.snp.trailing).offset(LayoutAdapter.shared.scale(value: 10))
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(reasonLabel.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 140))
        }
    }
    
    func configure(reason: String, isSelected: Bool, isTextFieldVisible: Bool) {
        reasonLabel.text = reason
        checkmarkView.image = isSelected ? UIImage(systemName: "checkmark.circle.fill") : UIImage(systemName: "circle")
        checkmarkView.tintColor = isSelected ? .brandColor : .color217
        textView.isHidden = !isTextFieldVisible
        if isTextFieldVisible {
            containerView.snp.updateConstraints { make in
                make.height.equalTo(LayoutAdapter.shared.scale(value: 212)) // 셀 높이 확장
            }
            textView.text = reason
        } else {
            containerView.snp.updateConstraints { make in
                make.height.equalTo(LayoutAdapter.shared.scale(value: 50)) // 기본 높이
            }
        }
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
