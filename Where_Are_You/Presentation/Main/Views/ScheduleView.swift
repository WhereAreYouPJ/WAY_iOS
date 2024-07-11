//
//  ScheduleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import Foundation
import UIKit

class ScheduleView: UIView {
    
    // MARK: - Properties

    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    private var schedules: [String] = []
    private var timer: Timer?
    
    // MARK: - Lifecycle

    init(schedules: [String]) {
        self.schedules = schedules
        super.init(frame: .zero)
        setupViews()
        startAutoScroll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setupViews() {
        scrollView.isPagingEnabled = true
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        setupSchedules()
    }
    
    private func setupSchedules() {
        for schedule in schedules {
            let label = UILabel()
            label.text = schedule
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        scrollView.contentSize = CGSize(width: frame.width, height: frame.height * CGFloat(schedules.count))
    }
    
    private func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextSchedule), userInfo: nil, repeats: true)
    }
    
    // MARK: - Selectors

    @objc private func scrollToNextSchedule() {
        let visibleRext = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRext.midX, y: visibleRext.midY)
        guard let visibleIndexPath = stackView.arrangedSubviews.firstIndex(where: { $0.frame.contains(visiblePoint) }) else { return }
        
        let nextIndex = (visibleIndexPath + 1) % schedules.count
        let nextOffset = CGPoint(x: 0, y: CGFloat(nextIndex) * frame.height)
        scrollView.setContentOffset(nextOffset, animated: true)
    }
    
    deinit {
        timer?.invalidate()
    }
}
