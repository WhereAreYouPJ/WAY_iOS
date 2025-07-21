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
    var scheduleSelected: Bool = false
    var isScheduleEmpty: Bool = true
    
    var onFeedCreated: (() -> Void)?
        
    let addFeedView = AddFeedView()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.color = .lightGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
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
        
        addFeedView.scheduleDropDown.dropDownTableView.delaysContentTouches = false
        addFeedView.scheduleDropDown.dropDownTableView.canCancelContentTouches = true

        addFeedView.scheduleDropDown.dropDownTableView.separatorInset = .zero
        addFeedView.scheduleDropDown.dropDownTableView.contentInset = .zero
        addFeedView.scheduleDropDown.dropDownTableView.sectionHeaderTopPadding = 0 //상단 여백 해결
        addFeedView.scheduleDropDown.dropDownTableView.layoutMargins = .zero
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
                guard let self = self else { return }
                let schedules = self.viewModel.getSchedules()

                self.addFeedView.scheduleDropDown.dropDownTableView.reloadData()
                // 1. 불러온 일정이 있는지 없는지 확인
                // 2. 불러온 일정이 없으면 테이블뷰를 hide하고 일정 없을때 뜨는 UI 보이게 하기
                // 선택된 일정의 정보를 표시
                if schedules.isEmpty {
                    self.isScheduleEmpty = true
                    self.addFeedView.scheduleDropDown.dropDownTableView.isHidden = true
                    self.addFeedView.scheduleDropDown.dropDownTableView.reloadData()
                } else {
                    self.isScheduleEmpty = false
                    self.addFeedView.scheduleDropDown.emptyView.isHidden = true
                    self.addFeedView.scheduleDropDown.dropDownTableView.reloadData()
                }
            }
        }
        
        viewModel.onScheduleSelected = { [weak self] in
            DispatchQueue.main.async {
                self?.scheduleSelected = true
                self?.checkUploadAvailability()
            }
        }
        
        viewModel.onFeedCreated = { [weak self] in
            DispatchQueue.main.async {
                self?.popViewController()
            }
        }
    }
    
    private func buttonActions() {
        addFeedView.scheduleDropDown.scheduleDropDownView.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
        addFeedView.titleTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        addFeedView.addImages.addTarget(self, action: #selector(handleAddImagesTapped), for: .touchUpInside)
        addFeedView.creatFeedButton.addTarget(self, action: #selector(createFeed), for: .touchUpInside)
        addFeedView.scheduleDropDown.moreButton.addTarget(self, action: #selector(loadMoreData), for: .touchUpInside)
    }
    
    func showLoadingFooter() {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: addFeedView.scheduleDropDown.dropDownTableView.bounds.width, height: 50))
        footerView.addSubview(loadingIndicator)
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        addFeedView.scheduleDropDown.dropDownTableView.tableFooterView = footerView
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingFooter() {
        loadingIndicator.stopAnimating()
        addFeedView.scheduleDropDown.dropDownTableView.tableFooterView = nil
    }
    
    func checkUploadAvailability() {
        if scheduleSelected, let title = addFeedView.titleTextField.text, !title.isEmpty {
            addFeedView.creatFeedButton.updateBackgroundColor(.brandMain)
            addFeedView.creatFeedButton.isEnabled = false
        } else {
            addFeedView.creatFeedButton.updateBackgroundColor(.blackAC)
            addFeedView.creatFeedButton.isEnabled = true
        }
    }
    
    // MARK: - Selectors
    @objc func loadMoreData() {
        print("loadMoreData tapped")
    }
    
    @objc func backButtonTapped() {
        popViewController()
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkUploadAvailability()
    }
    
    @objc func dropDownButtonTapped() {
        isDropdownVisible.toggle()
        let iconName = isDropdownVisible ? "chevron.up" : "chevron.down"
        addFeedView.scheduleDropDown.dropDownButton.image = UIImage(systemName: iconName)
        
        dropViewHeightConstraint.constant = isDropdownVisible ? LayoutAdapter.shared.scale(value: 410) : LayoutAdapter.shared.scale(value: 50) // 테이블 뷰 포함 높이 조정
        
        if isDropdownVisible {
            updateDropDownHeight()
            addFeedView.scheduleDropDown.dropDownTableView.layer.zPosition = 1
            viewModel.fetchSchedules()
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        if isScheduleEmpty {
            addFeedView.scheduleDropDown.dropDownTableView.isHidden = isScheduleEmpty // 테이블 뷰 표시/숨김 처리
            addFeedView.scheduleDropDown.emptyView.isHidden = !isDropdownVisible
        } else {
            addFeedView.scheduleDropDown.dropDownTableView.isHidden = !isDropdownVisible // 테이블 뷰 표시/숨김 처리
            addFeedView.scheduleDropDown.emptyView.isHidden = true
        }
    }
    
    @objc func createFeed() {
        // 피드 생성하기 버튼 눌림
        print("create tapped")
        guard let title = addFeedView.titleTextField.text, !title.isEmpty else { return }
        let content = addFeedView.contentTextView.text == "어떤 하루를 보냈나요?" ? nil : addFeedView.contentTextView.text
        
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
            textView.text = "어떤 하루를 보냈나요?"
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = viewModel.titleForHeader(in: section)
        let label = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "• \(headerText)", textColor: .brandDark))
        label.textAlignment = .left

        let container = UIView()
        container.preservesSuperviewLayoutMargins = false
        container.layoutMargins = .zero
        container.backgroundColor = .white
        container.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8)) // ← 여기 여백 조절
            make.top.bottom.equalToSuperview()
        }
        return container
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 29 // 너가 원하는 높이
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
            let date = schedule.startTime.prefix(10).replacingOccurrences(of: "-", with: ".")
            let shortDate = String(date.dropFirst(2))
            addFeedView.scheduleDropDown.scheduleDateLabel.updateTextKeepingAttributes(newText: "• \(shortDate)")
            
            addFeedView.scheduleDropDown.scheduleLocationLabel.text = schedule.title
            
            // 선택된 일정 정보에 맞춰 라벨 보이기 설정
            addFeedView.scheduleDropDown.scheduleDateLabel.isHidden = false
            addFeedView.scheduleDropDown.scheduleLocationLabel.isHidden = false
            addFeedView.scheduleDropDown.chooseScheduleLabel.isHidden = true
            
            dropDownButtonTapped()
            
            // 선택된 일정에 참가자 정보를 가져와 업데이트

            viewModel.fetchParticipants(for: schedule.scheduleSeq) { [weak self] in
                DispatchQueue.main.async {
                    guard let participantInfo = self?.viewModel.getParticipants() else { return }
                    if participantInfo.isEmpty {
                        self?.addFeedView.membersInfo.isHidden = true
                    } else {
                        self?.addFeedView.membersInfo.isHidden = false
                        self?.addFeedView.membersInfo.descriptionLabel.updateTextKeepingAttributes(newText: participantInfo)
                    }
                }
            }
        }
    }
    
    // 테이블뷰 하단 당겨서 추가 데이터 불러오는 로직
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y // frame영역의 origin에 비교했을때의 content view의 현재 origin 위치
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height // 화면에는 frame만큼 가득 찰 수 있기때문에 frame의 height를 빼준 것

        // 스크롤 할 수 있는 영역보다 더 스크롤된 경우 (하단에서 스크롤이 더 된 경우)
        if maximumOffset < currentOffset {
            showLoadingFooter()
            viewModel.fetchSchedules()
            
            // 예시로 로딩 사라지게
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.hideLoadingFooter()
            }
        }
    }

    func updateDropDownHeight() {
        let rowHeight = LayoutAdapter.shared.scale(value: 62)
        let numberOfRows = viewModel.totalNumberOfRows()
        let totalHeight = CGFloat(numberOfRows) * rowHeight + LayoutAdapter.shared.scale(value: 50)
        let maxHeight = LayoutAdapter.shared.scale(value: 460)
        
//        dropViewHeightConstraint.constant = min(totalHeight, maxHeight)
        dropViewHeightConstraint.constant = LayoutAdapter.shared.scale(value: 410)
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate

extension AddFeedViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
    
    @objc func handleAddImagesTapped() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10 - selectedImages.count  // 최대 선택 가능 사진 수
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
