//
//  Utilities.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/5/2024.
//

import UIKit

class Utilities {
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
}
