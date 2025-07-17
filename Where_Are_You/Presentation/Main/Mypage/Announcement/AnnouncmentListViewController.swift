//
//  AnnouncmentListViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2025.
//

import UIKit

class AnnouncmentListViewController: UIViewController {
    
    let tableView = UITableView()
    
    var viewModel: AnnouncementViewModel!
    var announcementListData: [Announcement] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupBindings()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchAnnouncement()
    }
    
    private func setupViewModel() {
        viewModel = AnnouncementViewModel()
    }
    
    private func setupBindings() {
        viewModel.onGetAnnouncement = { [weak self] data in
            self?.announcementListData = data
        }
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .zero

        tableView.estimatedRowHeight = LayoutAdapter.shared.scale(value: 66)
        tableView.register(AnnouncmentListTableViewCell.self, forCellReuseIdentifier: AnnouncmentListTableViewCell.identifier)
    }
    
    private func setupActions() {
        configureNavigationBar(title: "공지사항", backButtonAction: #selector(backButtonTapped))
    }
    
    @objc func backButtonTapped() {
        popViewController()
    }
}

extension AnnouncmentListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcementListData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AnnouncmentListTableViewCell.identifier, for: indexPath) as? AnnouncmentListTableViewCell else {
            return UITableViewCell()
        }
        let announcement = viewModel.announcement[indexPath.row]
        cell.configureUI(announcement: announcement)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAnnouncement = announcementListData[indexPath.row]
        let detailVC = AnnouncementViewController(announcementData: selectedAnnouncement)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
