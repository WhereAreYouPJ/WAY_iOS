//
//  LocationBookMarkCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 17/9/2024.
//

import UIKit

class LocationBookMarkCell: UITableViewCell {
    let locationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 16))
        
        return label
    }()
}
