//
//  FeedTableViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 15/7/2024.
//

import UIKit

class FeedTableViewController: UIViewController {
    // MARK: - Properties

    let feedTableView = FeedTableView()
    var viewModel: FeedTableViewModel!
    
    // MARK: - Lifecycle

    override func loadView() {
        print("FeedTableViewController loadView called") // 디버그 로그
        view = feedTableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FeedTableViewController viewDidLoad called") // 디버그 로그
        viewModel = FeedTableViewModel()
        setupBindings()
        setupTableView()
        setupActions()
        viewModel.fetchFeeds()
    }
    
    // MARK: - Helpers

    private func setupBindings() {
        viewModel.onFeedsDataFetched = { [weak self] in
            DispatchQueue.main.async {
                self?.feedTableView.feeds = self?.viewModel.getFeeds() ?? []
            }
        }
    }
    
    private func setupTableView() {
        print("Setting up table view") // 디버그 로그

        feedTableView.tableView.dataSource = self
        feedTableView.tableView.delegate = self
        feedTableView.tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
    }
    
    private func setupActions() {
        feedTableView.reminderButton.addTarget(self, action: #selector(reminderButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Selectors

    // 추후 피드 메인 컨트롤러 만들어야 함
    @objc private func reminderButtonTapped() {
        //        let feedViewController = FeedViewController()
        //        navigationController?.pushViewController(feedViewController, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FeedTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // reminderbutton 섹션, 피드 섹션
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section \(section)")
        switch section {
        case 0:
            return 0 // reminderbutton 섹션
        case 1:
            return viewModel.getFeeds().count // 피드 섹션
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("Cell for row at \(indexPath)")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
            fatalError("Unable to dequeue FeedTableViewCell")
        }
        let feed = viewModel.getFeeds()[indexPath.row]
        cell.configure(with: feed)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        print("View for header in section \(section)")

            if section == 1 {
                let headerView = UIView()
                headerView.addSubview(feedTableView.reminderButton)
                feedTableView.reminderButton.snp.makeConstraints { make in
                    make.edges.equalToSuperview().inset(16)
                }
                return headerView
            }
            return nil
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            print("Height for header in section \(section)")
            if section == 1 {
                return 50 // 헤더뷰의 높이 설정
            }
            return 0
        }
    
    // 해당 셀을 눌렀을때 피드 페이지로 넘어가게 설정
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let feed = viewModel.getFeeds()[indexPath.row]
        //        let detailViewController = FeedDetailViewController()
        //        detailViewController.configure(with: feed)
        //        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
