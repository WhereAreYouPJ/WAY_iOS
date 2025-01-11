//
//  InputFieldTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import UIKit
import SnapKit

class InputFieldTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = "InputFieldTableViewCell"
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 6
        tf.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        tf.textColor = .color34
        tf.backgroundColor = UIColor.rgb(red: 238, green: 238, blue: 238)
        return tf
    }()
    
    private var textChangeHandler: ((String) -> Void)?
    
    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(textField)
        
        textField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 16))
            make.leading.trailing.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
        }
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    func configure(placeholder: String, text: String, onTextChange: @escaping (String) -> Void) {
        textField.placeholder = placeholder
        textField.text = text
        textChangeHandler = onTextChange
    }
    
    @objc private func textDidChange(_ sender: UITextField) {
        textChangeHandler?(sender.text ?? "")
    }
}
