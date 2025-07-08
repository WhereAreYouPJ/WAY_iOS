//
//  EditFeedViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/1/2025.
//

import UIKit
import PhotosUI
import Kingfisher

class EditFeedViewController: UIViewController {
    // MARK: - Properties
    
    let editFeedView = EditFeedView()
    private var viewModel: EditFeedViewModel!
    private let feed: Feed // 수정할 피드 데이터
    
    private var selectedImages: [UIImage] = [] {
        didSet {
            viewModel.selectedImages = selectedImages // 뷰모델에 선택된 이미지를 전달합니다.
        }
    }
    var onFeedEdited: (() -> Void)?
    
    private var contentTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Initializer
    init(feed: Feed) {
        self.feed = feed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = editFeedView
        setupViewModel()
        setupNavigationBar()
        buttonActions()
        setupBindings()
        setupUI()
        setupFeedData()
    }
    
    // MARK: - Helpers
    
    private func setupViewModel() {
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        viewModel = EditFeedViewModel(editFeedUseCase: EditFeedUseCaseImpl(feedRepository: feedRepository))
    }
    
    private func setupNavigationBar() {
        configureNavigationBar(title: "피드 수정", backButtonAction: #selector(backButtonTapped))
    }
    
    private func buttonActions() {
        editFeedView.addImages.addTarget(self, action: #selector(handleAddImagesTapped), for: .touchUpInside)
        editFeedView.creatFeedButton.addTarget(self, action: #selector(editFeedButtonTapped), for: .touchUpInside)
    }
    
    private func setupBindings() {
        viewModel.onEditFeed = { [weak self] in
            DispatchQueue.main.async {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func setupUI() {
        editFeedView.imagesCollectionView.dataSource = self
        editFeedView.imagesCollectionView.delegate = self
        editFeedView.imagesCollectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: FeedImageCell.identifier)
    }
    
    private func setupFeedData() {
        editFeedView.configureUI(feed: feed)
        guard let feedImageInfos = feed.feedImageInfos else {
            print("No feedImageInfos found")
            return
        }
        let imageUrls = feedImageInfos.compactMap({ $0.feedImageURL })
        print("Image URLs: \(imageUrls)")
        loadFeedImages(imageUrls)
    }
    
    private func loadFeedImages(_ imageUrls: [String]) {
        for url in imageUrls {
            guard let imageURL = URL(string: url) else {
                print("Invalid URL: \(url)")
                continue
            }
            
            let resource = KF.ImageResource(downloadURL: imageURL)
            
            KingfisherManager.shared.retrieveImage(with: resource) { [weak self] result in
                switch result {
                case .success(let value):
                    DispatchQueue.main.async {
                        self?.selectedImages.append(value.image)
                        self?.editFeedView.imagesCollectionView.isHidden = self?.selectedImages.isEmpty ?? true

                        self?.editFeedView.imagesCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to load image: \(error.localizedDescription)")
                }
            }
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editFeedButtonTapped() {
        guard let title = editFeedView.titleTextField.text, !title.isEmpty else { return }
        let content = editFeedView.contentTextView.text == "어떤 일이 있었나요?" ? nil : editFeedView.contentTextView.text
        viewModel.editFeed(feedSeq: feed.feedSeq, title: title, content: content)
        self.onFeedEdited?()
    }
}

// MARK: - UITextViewDelegate

extension EditFeedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .color118 else { return }
        textView.text = nil
        textView.textColor = .black22
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "어떤 일이 있었나요?"
            textView.textColor = .color118
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        contentTextViewHeightConstraint.constant = max(estimatedSize.height, LayoutAdapter.shared.scale(value: 110))
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate

extension EditFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @objc func handleAddImagesTapped() {
        let remainingSelectionLimit = max(10 - selectedImages.count, 0) // 최대 10개 제한, 남은 선택 가능 수 계산
        guard remainingSelectionLimit > 0 else {
            print("최대 10개의 이미지만 추가할 수 있습니다.")
            return
        }
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = remainingSelectionLimit  // 최대 선택 가능 사진 수
        configuration.filter = .images  // 이미지만 선택할 수 있도록 설정
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            viewModel.selectedImages.append(image)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        let remainingCapacity = max(10 - selectedImages.count, 0) // 남은 이미지 추가 가능 수
        let imagesToAdd = min(results.count, remainingCapacity) // 추가할 이미지 수 제한
        
//        selectedImages.removeAll() // 초기화
        var addedImages = 0
        let group = DispatchGroup()
        
        for result in results {
            if addedImages >= imagesToAdd { break } // 추가할 이미지 수를 초과하면 중지
            
            group.enter()
            result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
                if let data = data, let image = UIImage(data: data) {
                    self?.selectedImages.append(image)
                    addedImages += 1
                } else if let error = error {
                    print("이미지를 불러오는 중 오류 발생: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.editFeedView.imagesCollectionView.reloadData()
            self?.editFeedView.imagesCollectionView.isHidden = self?.selectedImages.isEmpty ?? true
        }
    }
}

// MARK: - ImageCollectionView

extension EditFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FeedImageCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else {
            return UICollectionViewCell()
        }
        let image = selectedImages[indexPath.item]
        cell.configure(with: image)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: LayoutAdapter.shared.scale(value: 268), height: LayoutAdapter.shared.scale(value: 232))
    }
    
    func didTapDeleteButton(in cell: FeedImageCell) {
        guard let indexPath = editFeedView.imagesCollectionView.indexPath(for: cell) else { return }
        selectedImages.remove(at: indexPath.item)
        editFeedView.imagesCollectionView.reloadData()
        
        // 만약 이미지가 모두 삭제된 경우 collectionView를 숨김
        editFeedView.imagesCollectionView.isHidden = selectedImages.isEmpty
    }
}
