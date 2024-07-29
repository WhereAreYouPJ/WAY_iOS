//
//  FeedTableView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class FeedTableView: UIView {
    
    // MARK: - Properties
    
    let tableView = UITableView()
    let headerView = UIView()
    
    // 새로 커스텀 버튼을 만들어서 추가하기
    let reminderButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "함께한 추억을 확인해보세요!", attributes: [NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 20)), NSAttributedString.Key.foregroundColor: UIColor.color34])
        
        attributedTitle.append(NSAttributedString(string: "   ⟩", attributes: [NSAttributedString.Key.font: UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: .medium, fontSize: 25)), NSAttributedString.Key.foregroundColor: UIColor.color172]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        return button
    }()
    
    let noFeedLabel: UILabel = {
        let label = UILabel()
        label.text = """
            오늘 하루 수고했던 일은 어떤 경험을 남기게 했나요?
            하루의 소중한 시간을 기록하고 오래 기억될 수 있도록 간직해보세요!
        """
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .color118
        label.layer.borderColor = UIColor.color221.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        return label
    }()
    
    var feeds: [Feed] = [] {
        didSet {
            updateFeeds()
        }
    }
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setupViews() {
        addSubview(headerView)
        headerView.addSubview(reminderButton)
        addSubview(tableView)
        
        headerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        reminderButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
//            make.leading.trailing.equalToSuperview().inset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.estimatedRowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
//        tableView.separatorStyle = .none
    }
    
    private func updateFeeds() {
        if feeds.isEmpty {
            addSubview(noFeedLabel)
            noFeedLabel.snp.makeConstraints { make in
                make.edges.equalToSuperview().inset(16)
            }
            tableView.isHidden = true
        } else {
            noFeedLabel.removeFromSuperview()
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
