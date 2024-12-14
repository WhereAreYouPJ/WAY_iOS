//
//  FeedsTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 8/8/2024.
//

import UIKit
import Kingfisher

protocol FeedsTableViewCellDelegate: AnyObject {
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool)
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect)
}

class FeedsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FeedsTableViewCell"
    weak var delegate: FeedsTableViewCellDelegate?
    
    private var feed: Feed?
    private var feedSeq: Int?
    private var isBookMarked: Bool = false
    private var imageUrls: [String] = []
    
    let detailBox = FeedDetailBoxView()
    let feedImagesView = FeedImagesView()
    let bookMarkButton = UIButton()
    
    let descriptionLabel: UILabel = {
        let label = CustomLabel(UILabel_NotoSans: .medium, text: "asdasdasd", textColor: .color34, fontSize: LayoutAdapter.shared.scale(value: 14))
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingHead
        return label
    }()
    
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
        
        bookMarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        detailBox.feedFixButton.addTarget(self, action: #selector(feedFixButtonTapped), for: .touchUpInside)
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
    
    func configure(with feed: Feed) {
        descriptionLabel.isHidden = (feed.content == nil)
        descriptionLabel.text = feed.content
        detailBox.configure(with: feed)
        let feedImageInfos = feed.feedImageInfos ?? []
        self.imageUrls = feedImageInfos.map { $0.feedImageURL }
        feedImagesView.collectionView.reloadData()
        feedImagesView.pageNumberLabel.text = "1/\(imageUrls.count)"
        
        self.feed = feed
        feedSeq = feed.feedSeq
        isBookMarked = feed.bookMark
        updateBookMarkUI()
    }
    
    private func updateBookMarkUI() {
        let iconName = isBookMarked ? "icon-feed_bookmark_filled" : "icon-feed_bookmark"
        bookMarkButton.setImage(UIImage(named: iconName), for: .normal)
    }
    
    // MARK: - Selectors
    
    @objc private func bookmarkButtonTapped() {
        guard let feedSeq = feedSeq else { return }
        self.isBookMarked.toggle()
        self.updateBookMarkUI()
        delegate?.didTapBookmarkButton(feedSeq: feedSeq, isBookMarked: isBookMarked)
    }
    
    @objc private func feedFixButtonTapped() {
        guard let feed = feed else { return }
        delegate?.didTapFeedFixButton(feed: feed, buttonFrame: detailBox.feedFixButton.convert(detailBox.feedFixButton.bounds, to: nil))
    }
}

extension FeedsTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCollectionViewCell.identifier, for: indexPath) as? FeedImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let imageUrlString = imageUrls[indexPath.item]
        cell.configure(with: imageUrlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        let pageWidth = collectionView.frame.width
        let pageIndex = Int(collectionView.contentOffset.x / pageWidth)
        feedImagesView.pageNumberLabel.text = "\(pageIndex + 1)/\(imageUrls.count)"
    }
}
