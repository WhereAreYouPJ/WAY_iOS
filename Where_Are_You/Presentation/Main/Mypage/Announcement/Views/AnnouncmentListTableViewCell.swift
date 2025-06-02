//
//  AnnouncmentListTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/5/2025.
//

import UIKit

class AnnouncmentListTableViewCell: UITableViewCell {
    static let identifier = "AnnouncmentListTableViewCell"
    
    let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "t", textColor: .black22))
    let dateLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "d", textColor: .blackAC))
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        sv.axis = .vertical
        sv.spacing = 4
        return sv
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewComponents() {
        addSubview(labelStackView)
    }
    
    private func setupConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24, basedOnHeight: false))
        }
    }
    
    func configureUI(announcement: Announcement) {
        titleLabel.updateTextKeepingAttributes(newText: announcement.title)
        dateLabel.updateTextKeepingAttributes(newText: announcement.date)
    }
}
