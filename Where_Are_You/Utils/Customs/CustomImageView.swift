//
//  CustomImageView.swift
//  Where_Are_You
//
//  Created by 오정석 on 25/2/2025.
//

import UIKit

class RoundImageView: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
