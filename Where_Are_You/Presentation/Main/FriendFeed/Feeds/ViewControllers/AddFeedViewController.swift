//
//  AddFeedViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

import UIKit

class AddFeedViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: AddFeedViewModel!

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
        let scheduleRepository = ScheduleRepository(scheduleService: scheduleService)
        viewModel = AddFeedViewModel(getScheduleListUseCase: GetScheduleListUseCaseImpl(scheduleRepository: scheduleRepository))
    }
    
    private func setupTableView() {
        addFeedView.scheduleDropDown.dropDownTableView.delegate = self
        addFeedView.scheduleDropDown.dropDownTableView.dataSource = self
        addFeedView.scheduleDropDown.dropDownTableView.register(ScheduleDropDownCell.self, forCellReuseIdentifier: ScheduleDropDownCell.identifier)
    }
    
    private func setupNavigationBar() {
        Utilities.createNavigationBar(for: self, title: "새 피드 작성", backButtonAction: #selector(backButtonTapped), showBackButton: true)
    }
    
    private func setupUI() {
        dropViewHeightConstraint = addFeedView.scheduleDropDown.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 50))
        dropViewHeightConstraint.isActive = true
        
        addFeedView.contentTextView.delegate = self
        
        // 텍스트 뷰의 높이 제약 조건 저장
        contentTextViewHeightConstraint = addFeedView.contentTextView.heightAnchor.constraint(equalToConstant: LayoutAdapter.shared.scale(value: 110))
        contentTextViewHeightConstraint.isActive = true
    }
    
    private func setupBindings() {
        viewModel.onSchedulesUpadated = { [weak self] in
            DispatchQueue.main.async {
                self?.addFeedView.scheduleDropDown.dropDownTableView.reloadData()
            }
        }
    }
    
    private func buttonActions() {
        addFeedView.scheduleDropDown.scheduleDropDownView.addTarget(self, action: #selector(dropDownButtonTapped), for: .touchUpInside)
        addFeedView.addImages.addTarget(self, action: #selector(addImagesTapped), for: .touchUpInside)
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
        
        dropViewHeightConstraint.constant = isDropdownVisible ? LayoutAdapter.shared.scale(value: 356) : LayoutAdapter.shared.scale(value: 50) // 테이블 뷰 포함 높이 조정
        addFeedView.scheduleDropDown.dropDownTableView.isHidden = !isDropdownVisible // 테이블 뷰 표시/숨김 처리
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func addImagesTapped() {
        // 사진 추가 버튼 눌림
    }
    
    @objc func createFeed() {
        // 피드 생성하기 버튼 눌림
        guard let scheduleSeq = viewModel.selectedScheduleSeq else { return }
    }
}

extension AddFeedViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .color118 else { return }
        textView.text = nil
        textView.textColor = .color34
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

extension AddFeedViewController: AddFeedViewModelDelegate {
    func didUpdateSchedules() {
        addFeedView.scheduleDropDown.dropDownTableView.reloadData()
    }
}

extension AddFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForHeader(in: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleDropDownCell.identifier, for: indexPath) as? ScheduleDropDownCell else { return UITableViewCell() }
        let schedule = viewModel.schedule(for: indexPath)
        cell.configure(with: schedule)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let schedule = viewModel.schedule(for: indexPath)
        
        if !schedule.feedGet {
            // 선택된 일정의 seq를 ViewModel에 전달
            viewModel.selectSchedule(at: indexPath)
            
            // 참가자 정보 표시 등 추가 작업
            // 예: scheduleSeq를 이용해 참가자 데이터를 표시하는 로직 구현
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
}
