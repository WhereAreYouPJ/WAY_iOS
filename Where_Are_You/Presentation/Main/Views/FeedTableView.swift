//
//  FeedTableView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class FeedTableView: UIView {
    let tableView = UITableView()
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
    
    var feeds: [String] = [] {
        didSet {
            updateFeeds()
        }
    }

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
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
