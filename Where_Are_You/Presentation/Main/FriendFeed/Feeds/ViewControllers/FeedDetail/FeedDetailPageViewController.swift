//
//  FeedDetailPageViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 14/1/2025.
//

import UIKit

class FeedDetailPageViewController: UIPageViewController {
    // MARK: - Properties
    var feeds: [Feed] // 각 참가자의 피드 데이터 배열
    private var currentIndex: Int = 0 // 현재 보여지는 페이지 인덱스
    
    // MARK: - Lifecycle
    init(feeds: [Feed], startIndex: Int) {
        self.feeds = feeds
        self.currentIndex = startIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
    }
    
    // MARK: - Helpers
    private func setupPageViewController() {
        dataSource = self
        delegate = self
        
        // 초기 화면 설정
        if let initialViewController = detailViewController(for: currentIndex) {
            setViewControllers([initialViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func detailViewController(for index: Int) -> FeedDetailViewController? {
        guard index >= 0 && index < feeds.count else { return nil }
        let feed = feeds[index]
        let viewController = FeedDetailViewController(feed: feed)
        return viewController
    }
}

// MARK: - UIPageViewControllerDataSource
extension FeedDetailPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let previousIndex = currentIndex - 1
        return detailViewController(for: previousIndex)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let nextIndex = currentIndex + 1
        return detailViewController(for: nextIndex)
    }
}

// MARK: - UIPageViewControllerDelegate
extension FeedDetailPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed, let currentViewController = viewControllers?.first as? FeedDetailViewController,
              let index = feeds.firstIndex(where: { $0.feedSeq == currentViewController.feed.feedSeq }) else { return }
        currentIndex = index
    }
}
