//
//  FeedsTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit

class FeedsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FeedsTableViewCell"
    
    let detailBox = FeedDetailBoxView()
    let feedImagesView = FeedImagesView()
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icon-feed_bookmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    let descriptionLabel: UILabel = {
        let label = CustomLabel(UILabel_NotoSans: .medium, text: "asdasdasd", textColor: .color34, fontSize: LayoutAdapter.shared.scale(value: 14))
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingHead
        return label
    }()
    
    private var imageUrls: [String] = []
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        contentView.addSubview(detailBox)
        contentView.addSubview(feedImagesView)
        contentView.addSubview(bookMarkButton)
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.backgroundColor = .color249
    }
    
    private func setupConstraints() {
        detailBox.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 74))
        }
        
        feedImagesView.snp.makeConstraints { make in
            make.top.equalTo(detailBox.snp.bottom).offset(LayoutAdapter.shared.scale(value: 10))
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 290))
        }
        
        bookMarkButton.snp.makeConstraints { make in
            make.top.equalTo(feedImagesView.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 30))
            make.trailing.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(bookMarkButton.snp.bottom).offset(LayoutAdapter.shared.scale(value: 6))
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setupCollectionView() {
        feedImagesView.collectionView.delegate = self
        feedImagesView.collectionView.dataSource = self
        feedImagesView.collectionView.register(FeedImageCollectionViewCell.self, forCellWithReuseIdentifier: FeedImageCollectionViewCell.identifier)
    }
    
    func configure(with feed: MainFeedListContent) {
        if feed.content == nil {
            self.descriptionLabel.isHidden = true
        } else {
            descriptionLabel.isHidden = false
            descriptionLabel.text = feed.content
        }
        
        detailBox.profileImage.setImage(from: feed.profileImage, placeholder: UIImage(named: "basic_profile_image"))
        detailBox.dateLabel.text = feed.startTime.formattedDate(to: .yearMonthDate)
        detailBox.locationLabel.text = feed.location
        detailBox.titleLabel.text = feed.title
        self.imageUrls = feed.feedImageInfos.map { $0.feedImageURL }
        feedImagesView.collectionView.reloadData()
        
        feedImagesView.pageControl.numberOfPages = imageUrls.count
        feedImagesView.pageControl.currentPage = 0
    }
}

extension FeedsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCollectionViewCell.identifier, for: indexPath) as? FeedImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageUrl = imageUrls[indexPath.item]
        cell.configure(with: UIImage(named: "placeholder")) // Placeholder 적용
        cell.imageView.setImage(from: imageUrl, placeholder: UIImage(named: "placeholder")) // 비동기로 이미지 로드
        return cell
    }
}

extension FeedsTableViewCell: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            guard let collectionView = scrollView as? UICollectionView else { return }
            let pageIndex = Int(collectionView.contentOffset.x / collectionView.frame.width)
            feedImagesView.pageControl.currentPage = pageIndex
        }
}
