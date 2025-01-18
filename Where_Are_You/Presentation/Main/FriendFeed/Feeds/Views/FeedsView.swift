//
//  FeedsView.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class FeedsView: UIView {
    // MARK: - Properties
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let feedsTableView = UITableView()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - helpers
    
    private func configureViewComponents() {
        backgroundColor = .white
        
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(feedsTableView)
        feedsTableView.separatorStyle = .none
        feedsTableView.isScrollEnabled = false
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
            make.height.equalTo(1)
        }
        
        feedsTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().priority(.low)
        }
    }
    
    func updateContentHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.feedsTableView.layoutIfNeeded()
            let contentHeight = max(self.feedsTableView.contentSize.height, UIScreen.main.bounds.height)
            self.contentView.snp.updateConstraints { make in
                make.height.equalTo(contentHeight)
            }
        }
    }
}
