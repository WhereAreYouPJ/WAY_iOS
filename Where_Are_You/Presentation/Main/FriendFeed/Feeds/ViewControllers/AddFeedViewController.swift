//
//  AddFeedViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

import UIKit
import PhotosUI

class AddFeedViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: AddFeedViewModel!
    private var selectedImages: [UIImage] = [] {
        didSet {
            viewModel.selectedImages = selectedImages // 뷰모델에 선택된 이미지를 전달합니다.
        }
    }
    
    var onFeedCreated: (() -> Void)?
        
    let addFeedView = AddFeedView()
    private var dropViewHeightConstraint: NSLayoutConstraint!
    private var isDropdownVisible = false
    private var contentTextViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = addFeedView
        setupViewModel()
        setupNavigationBar()
        buttonActions()
        setupBindings()
        setupUI()
        setupTableView()
        viewModel.delegate = self
        viewModel.fetchSchedules()
    }
    
    // MARK: - Helpers
    private func setupViewModel() {
        let scheduleService = ScheduleService()
        let feedService = FeedService()
        let feedRepository = FeedRepository(feedService: feedService)
        let scheduleRepository = ScheduleRepository(scheduleService: scheduleService)
        viewModel = AddFeedViewModel(
            getScheduleListUseCase: GetScheduleListUseCaseImpl(scheduleRepository: scheduleRepository),
            saveFeedUseCase: SaveFeedUseCaseImpl(feedRepository: feedRepository),
            getScheduleUseCase: GetScheduleUseCaseImpl(scheduleRepository: scheduleRepository))
    }
    
    private func setupTableView() {
        addFeedView.scheduleDropDown.dropDownTableView.delegate = self
        addFeedView.scheduleDropDown.dropDownTableView.dataSource = self
        addFeedView.scheduleDropDown.dropDownTableView.register(ScheduleDropDownCell.self, forCellReuseIdentifier: ScheduleDropDownCell.identifier)
    }
    
    private func setupNavigationBar() {
        configureNavigationBar(title: "새 피드 작성", backButtonAction: #selector(backButtonTapped))
    }
    
    private func setupUI() {
        dropViewHeightConstraint = addFeedView.scheduleDropDown.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 50))
        dropViewHeightConstraint.isActive = true
        
        addFeedView.contentTextView.delegate = self
        addFeedView.imagesCollectionView.dataSource = self
        addFeedView.imagesCollectionView.delegate = self
        
        addFeedView.imagesCollectionView.register(FeedImageCell.self, forCellWithReuseIdentifier: FeedImageCell.identifier)
        
        // 텍스트 뷰의 높이 제약 조건 저장
        contentTextViewHeightConstraint = addFeedView.contentTextView.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 110))
        contentTextViewHeightConstraint.isActive = true
    }
    
    private func setupBindings() {
        viewModel.onSchedulesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.addFeedView.scheduleDropDown.dropDownTableView.reloadData()
                // 선택된 일정의 정보를 표시
                if (self?.viewModel.selectedSchedule) != nil {
                    self?.addFeedView.scheduleDropDown.chooseScheduleLabel.isHidden = true
                }
            }
        }
        
        viewModel.onFeedCreated = { [weak self] in
            DispatchQueue.main.async {
                self?.dismiss(animated: true)
            }
        }
    }
    
    private func buttonActions() {
        addFeedView.scheduleDropDown.scheduleDropDownView.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
        addFeedView.addImages.addTarget(self, action: #selector(handleAddImagesTapped), for: .touchUpInside)
        addFeedView.creatFeedButton.button.addTarget(self, action: #selector(createFeed), for: .touchUpInside)
    }
    
    // MARK: - Selectors
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func dropDownButtonTapped() {
        isDropdownVisible.toggle()
        let iconName = isDropdownVisible ? "chevron.up" : "chevron.down"
        addFeedView.scheduleDropDown.dropDownButton.image = UIImage(systemName: iconName)
        
        dropViewHeightConstraint.constant = isDropdownVisible ? LayoutAdapter.shared.scale(value: 460) : LayoutAdapter.shared.scale(value: 50) // 테이블 뷰 포함 높이 조정
        
        if isDropdownVisible {
            updateDropDownHeight()
            addFeedView.scheduleDropDown.dropDownTableView.layer.zPosition = 1
            viewModel.fetchSchedules()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        addFeedView.scheduleDropDown.dropDownTableView.isHidden = !isDropdownVisible // 테이블 뷰 표시/숨김 처리
    }
    
    @objc func createFeed() {
        // 피드 생성하기 버튼 눌림
        print("createFeed 눌림")
        guard let title = addFeedView.titleTextField.text, !title.isEmpty else { return }
        let content = addFeedView.contentTextView.text == "어떤 일이 있었나요?" ? nil : addFeedView.contentTextView.text
        
        viewModel.saveFeed(title: title, content: content)
        self.onFeedCreated?()
    }
}

// MARK: - UITextViewDelegate

extension AddFeedViewController: UITextViewDelegate {
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

// MARK: - AddFeedViewModelDelegate

extension AddFeedViewController: AddFeedViewModelDelegate {
    func didUpdateSchedules() {
        addFeedView.scheduleDropDown.dropDownTableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AddFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = LayoutAdapter.shared.scale(value: 62)
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleDropDownCell.identifier, for: indexPath) as? ScheduleDropDownCell else { return UITableViewCell() }
        let schedule = viewModel.schedule(for: indexPath)
        cell.configure(with: schedule)
        // `feedExists`가 true이면 선택 불가하도록 설정
        if schedule.feedExists {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
            cell.alpha = 1.0
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = viewModel.schedule(for: indexPath)
        
        if !schedule.feedExists {
            viewModel.selectSchedule(at: indexPath)
            
            // 선택된 일정의 정보로 label 업데이트
            let dateParts = schedule.startTime.prefix(10).split(separator: "-")
            if dateParts.count == 3 {
                let year = "\(dateParts[0])."  // 연도
                let monthDay = "\(dateParts[1]).\(dateParts[2])"  // 월.일
                
                // 두 줄로 날짜 표시
                addFeedView.scheduleDropDown.scheduleDateLabel.text = "\(year)\n\(monthDay)"
            }
            
            addFeedView.scheduleDropDown.scheduleLocationLabel.text = schedule.title
            
            // 선택된 일정 정보에 맞춰 라벨 보이기 설정
            addFeedView.scheduleDropDown.scheduleDateLabel.isHidden = false
            addFeedView.scheduleDropDown.scheduleLocationLabel.isHidden = false
            addFeedView.scheduleDropDown.chooseScheduleLabel.isHidden = true
            
            dropDownButtonTapped()
            
            // 선택된 일정에 참가자 정보를 가져와 업데이트

            viewModel.fetchParticipants(for: schedule.scheduleSeq) { [weak self] in
                DispatchQueue.main.async {
                    guard let participantInfo = self?.viewModel.getParticipants() else {
                        print("participantInfo is nil")
                        self?.addFeedView.membersInfo.isHidden = true
                        return
                    }
                    self?.addFeedView.membersInfo.isHidden = false
                    self?.addFeedView.membersInfo.descriptionLabel.text = participantInfo
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight {
            // 테이블 뷰 끝에 도달했을 때 다음 페이지의 데이터를 불러옴
            viewModel.fetchSchedules()
        }
    }
    
    func updateDropDownHeight() {
        let rowHeight = LayoutAdapter.shared.scale(value: 62)
        let numberOfRows = viewModel.totalNumberOfRows()
        let totalHeight = CGFloat(numberOfRows) * rowHeight + LayoutAdapter.shared.scale(value: 50)
        let maxHeight = LayoutAdapter.shared.scale(value: 460)
        
        dropViewHeightConstraint.constant = min(totalHeight, maxHeight)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate

extension AddFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @objc func handleAddImagesTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10  // 최대 선택 가능 사진 수
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
        
        selectedImages.removeAll() // 초기화
        
        let group = DispatchGroup()
        for result in results {
            group.enter()
            result.itemProvider.loadDataRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] data, error in
                if let data = data, let image = UIImage(data: data) {
                    self?.selectedImages.append(image)
                } else if let error = error {
                    print("이미지를 불러오는 중 오류 발생: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.addFeedView.imagesCollectionView.reloadData()
            self?.addFeedView.imagesCollectionView.isHidden = self?.selectedImages.isEmpty ?? true
        }
    }
}

// MARK: - ImageCollectionView

extension AddFeedViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FeedImageCellDelegate {
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
        guard let indexPath = addFeedView.imagesCollectionView.indexPath(for: cell) else { return }
        selectedImages.remove(at: indexPath.item)
        addFeedView.imagesCollectionView.reloadData()
        
        // 만약 이미지가 모두 삭제된 경우 collectionView를 숨김
        addFeedView.imagesCollectionView.isHidden = selectedImages.isEmpty
    }
}
