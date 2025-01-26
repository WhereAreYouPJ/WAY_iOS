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
    func didSelectFeed(feed: Feed)
}

class FeedsTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "FeedsTableViewCell"
    weak var delegate: FeedsTableViewCellDelegate?
    
    private var feed: Feed?
    private var profileImageURL: String = ""
    private var feedSeq: Int?
    private var isBookMarked: Bool = false
    private var imageUrls: [String] = []
    var isExpanded: Bool = false
    
    let detailBox = FeedDetailBoxView()
    let feedImagesView = FeedImagesView()
    let bookMarkButton = UIButton()
    
    let descriptionLabel: UILabel = {
        let label = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .black22, fontSize: LayoutAdapter.shared.scale(value: 14))
        label.isHidden = true
        label.lineBreakMode = .byCharWrapping
        label.backgroundColor = .color249
        return label
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.addSubview(detailBox)
        contentView.addSubview(feedImagesView)
        contentView.addSubview(bookMarkButton)
        contentView.addSubview(descriptionLabel)
    }
    
    private func setupActions() {
        bookMarkButton.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        detailBox.feedFixButton.addTarget(self, action: #selector(feedFixButtonTapped), for: .touchUpInside)
        let detailBoxTapGesture = UITapGestureRecognizer(target: self, action: #selector(detailBoxTapped))
        detailBox.addGestureRecognizer(detailBoxTapGesture)
        detailBox.isUserInteractionEnabled = true // 터치 이벤트 활성화
        
        let descriptionLabelTapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionLabelTapped))
        descriptionLabel.isUserInteractionEnabled = true // UILabel에서 제스처를 받을 수 있도록 설정
        descriptionLabel.addGestureRecognizer(descriptionLabelTapGesture)
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
//            make.height.width.equalTo(LayoutAdapter.shared.scale(value: 30))
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
    
    func resetUI() {
        feedImagesView.pageNumberLabel.text = nil
        feedSeq = nil
        isBookMarked = false
        profileImageURL = ""
    }
    
    func configure(with feed: Feed) {
        print("configure FeedsTableViewCell")
        resetUI()
        
        descriptionLabel.isHidden = (feed.content == nil)
//        descriptionLabel.text = feed.content
        guard let feedcontent = feed.content else { return }
        descriptionLabel.attributedText = UIFont.CustomFont.bodyP4(text: feedcontent)
        let readmoreFont = UIFont.pretendard(NotoSans: .medium, fontSize: 14)
        let readmoreFontColor = UIColor.color153
        descriptionLabel.numberOfLines = isExpanded ? 0 : 3
        
        // 레이아웃을 강제로 갱신한 뒤 "더 보기" 추가
        descriptionLabel.layoutIfNeeded()
        if !isExpanded {
            DispatchQueue.main.async {
                self.descriptionLabel.addTrailing(with: "...", moreText: "  더 보기", moreTextFont: readmoreFont, moreTextColor: readmoreFontColor)
            }
        }
        
        detailBox.configure(with: feed)
        
        let feedImageInfos = feed.feedImageInfos ?? []
        self.imageUrls = feedImageInfos.map { $0.feedImageURL }
        feedImagesView.collectionView.reloadData()
        if imageUrls.count <= 1 {
            feedImagesView.pageNumberLabel.isHidden = true
        } else {
            feedImagesView.pageNumberLabel.isHidden = false
            feedImagesView.pageNumberLabel.text = "1/\(imageUrls.count)"
        }
        
        self.feed = feed
        profileImageURL = feed.profileImageURL
        feedSeq = feed.feedSeq
        isBookMarked = feed.bookMark
        updateBookMarkUI()
        
        print("descriptionLabel frame: \(descriptionLabel.frame)")
        print("cell frame: \(self.frame)")

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
        let buttonFrame = detailBox.feedFixButton.convert(detailBox.feedFixButton.bounds, to: self.window)
        
        delegate?.didTapFeedFixButton(feed: feed, buttonFrame: buttonFrame)
    }
    
    @objc private func detailBoxTapped() {
        guard let feed = feed else { return }
        
        delegate?.didSelectFeed(feed: feed)
    }
    
    @objc private func descriptionLabelTapped() {
        guard !isExpanded else { return } // 이미 펼쳐졌다면 아무 작업도 하지 않음
        
        isExpanded = true // 상태 변경
        descriptionLabel.numberOfLines = 0 // 텍스트 전체 표시
        descriptionLabel.gestureRecognizers?.forEach { descriptionLabel.removeGestureRecognizer($0) } // "더보기" 제스처 제거
 
        // 테이블뷰 레이아웃 업데이트
        if let tableView = superview as? UITableView, let indexPath = tableView.indexPath(for: self) {
            // 레이아웃 강제 업데이트
            UIView.performWithoutAnimation { // 애니메이션 없이 즉시 갱신
                tableView.reloadRows(at: [indexPath], with: .none) // 해당 셀 높이 갱신
            }
        }
    }
}
extension FeedsTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIScrollViewDelegate {
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
