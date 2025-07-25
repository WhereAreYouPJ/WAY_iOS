//
//  CommonFeedView.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/1/2025.
//

import UIKit
import Kingfisher

protocol CommonFeedViewDelegate: AnyObject {
    func didTapBookmarkButton(feedSeq: Int, isBookMarked: Bool)
    func didTapFeedFixButton(feed: Feed, buttonFrame: CGRect)
}

class CommonFeedView: UIView {
    // MARK: - Properties
    weak var delegate2: CommonFeedViewDelegate?

    private var feed: Feed?
    private var profileImageURL: String = ""
    private var feedSeq: Int?
    private var isBookMarked: Bool = false
    private var imageUrls: [String] = []
    
    let detailBox = FeedDetailBoxView()
    let feedImagesView = FeedImagesView()
    let bookMarkButton = UIButton()
    
    let descriptionLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "d", textColor: .black22))
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        descriptionLabel.isHidden = true
        descriptionLabel.backgroundColor = .blackF8
        configureViewComponents()
        setupActions()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    private func configureViewComponents() {
        addSubview(detailBox)
        addSubview(feedImagesView)
        addSubview(bookMarkButton)
        addSubview(descriptionLabel)
    }
    
    private func setupActions() {
        bookMarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        detailBox.feedFixButton.addTarget(self, action: #selector(feedFixButtonTapped), for: .touchUpInside)
        detailBox.isUserInteractionEnabled = true // 터치 이벤트 활성화
    }
    
    private func setupConstraints() {
        detailBox.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.trailing.equalToSuperview()
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
        feedImagesView.collectionView.register(NoFeedImageViewCell.self, forCellWithReuseIdentifier: NoFeedImageViewCell.identifier)
    }
    
    func configure(with feed: Feed, delegate: CommonFeedViewDelegate?) {
        self.delegate2 = delegate

        descriptionLabel.isHidden = (feed.content == nil)
        guard let content = feed.content else { return }
        descriptionLabel.updateTextKeepingAttributes(newText: content)
        detailBox.configure(with: feed)
        detailBox.participantBoxView.isHidden = true
        let feedImageInfos = feed.feedImageInfos ?? []
        self.imageUrls = feedImageInfos.map { $0.feedImageURL }
        feedImagesView.collectionView.reloadData()
        if imageUrls.count == 0 {
            feedImagesView.pageNumberLabel.text = "1/1"
        } else {
            feedImagesView.pageNumberLabel.text = "1/\(imageUrls.count)"
        }
        self.feed = feed
        profileImageURL = feed.profileImageURL
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
        delegate2?.didTapBookmarkButton(feedSeq: feedSeq, isBookMarked: isBookMarked)
    }
    
    @objc private func feedFixButtonTapped() {
        guard let feed = feed else { return }
        guard let window = self.window else { return }
        
        let buttonFrame = detailBox.feedFixButton.convert(detailBox.feedFixButton.bounds, to: window)
        delegate2?.didTapFeedFixButton(feed: feed, buttonFrame: buttonFrame)
    }
}

extension CommonFeedView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let noFeedImage = imageUrls.count == 0
        return noFeedImage ? 1 : imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if imageUrls.count == 0 {
            // 피드에 이미지가 없는 경우
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoFeedImageViewCell.identifier, for: indexPath) as? NoFeedImageViewCell else {
                return UICollectionViewCell()
            }
            cell.configureUI(profileImage: profileImageURL)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCollectionViewCell.identifier, for: indexPath) as? FeedImageCollectionViewCell else {
                return UICollectionViewCell()
            }
            let imageUrlString = imageUrls[indexPath.item]
            cell.configure(with: imageUrlString)
            return cell
        }
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
