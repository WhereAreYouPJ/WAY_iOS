//
//  FeedTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class FeedTableViewCell: UITableViewCell {
    static let identifier = "FeedTableViewCell"
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        return iv
    }()
    
    private let locationLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color102, fontSize: 14)
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .color34, fontSize: 16)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        label.textColor = .color153
        label.numberOfLines = 3
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        textStackView.addArrangedSubview(locationLabel)
        textStackView.addArrangedSubview(titleLabel)
        
        mainStackView.addArrangedSubview(profileImageView)
        mainStackView.addArrangedSubview(textStackView)
        
        contentView.addSubview(mainStackView)
        contentView.addSubview(descriptionLabel)
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(contentView.snp.width).multipliedBy(0.15) // 프로필 이미지 크기
        }
        
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
        }
    }
    
    func configure(with feed: Feed) {
        profileImageView.image = feed.profileImage
        locationLabel.text = feed.location
        titleLabel.text = feed.title
        
        let maxDescriptionLines = 3
        let fullText = feed.description
        let truncatedText = truncateText(fullText, for: descriptionLabel, maxLines: maxDescriptionLines)
        
        let attributedString = NSMutableAttributedString(string: truncatedText)
        
        if truncatedText != fullText {
            let moreText = "... 더 보기"
            let moreAttributedString = NSAttributedString(string: moreText, attributes: [.foregroundColor: UIColor.blue])
            attributedString.append(moreAttributedString)
        }
        
        descriptionLabel.attributedText = attributedString
    }
    
    private func truncateText(_ text: String, for label: UILabel, maxLines: Int) -> String {
        let labelWidth = label.frame.width
        let attributes = [NSAttributedString.Key.font: label.font!]
        var low = 0
        var high = text.count
        var mid = 0
        var currentText = text
        
        while low < high {
            mid = (low + high) / 2
            let substring = String(text.prefix(mid))
            let size = (substring as NSString).boundingRect(with: CGSize(width: labelWidth, height: .greatestFiniteMagnitude), options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size
            
            if Int(size.height / label.font.lineHeight) <= maxLines {
                low = mid + 1
                currentText = substring
            } else {
                high = mid
            }
        }
        
        return currentText
    }
}
