//
//  ScheduleView.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/7/2024.
//

import UIKit
import SnapKit

class ScheduleView: UIView {
    // MARK: - Properties

    private let scrollView = UIScrollView()
    
    private let stackView = UIStackView()
    
    private let noScheduleLabel: UILabel = {
        let label = UILabel()
        label.text = "일정이 없습니다."
        label.textAlignment = .center
        label.layer.borderColor = UIColor.color118.cgColor
        label.textColor = .color191
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        return label
    }()
    
    private var timer: Timer?
    
    var schedules: [String] = [] {
        didSet {
            updateSchedules()
        }
    }
    
    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers

    private func setupViews() {
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalToSuperview()
        }
    }
    
    private func updateSchedules() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if schedules.isEmpty {
            stackView.addArrangedSubview(noScheduleLabel)
        } else {
            for schedule in schedules {
                let label = createScheduleLabel(with: schedule)
                stackView.addArrangedSubview(label)
            }
            startAutoScroll()
        }
    }
    
    private func createScheduleLabel(with schedule: String) -> UILabel {
        let label = UILabel()
        label.text = schedule
        label.textAlignment = .left
        label.backgroundColor = .white
        label.textColor = .color34
        label.layer.borderColor = UIColor.color118.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: 16)
        
        let attributedText = NSMutableAttributedString(string: schedule)
        attributedText.addAttribute(.foregroundColor, value: UIColor.scheduleDateColor, range: (schedule as NSString).range(of: "D -"))
        label.attributedText = attributedText
        
        return label
    }
    
    private func startAutoScroll() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextPage), userInfo: nil, repeats: true)
    }
    
    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func scrollToNextPage() {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: scrollView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let visibleIndexPath = stackView.arrangedSubviews.enumerated().first(where: { $0.element.frame.contains(visiblePoint) })?.offset else { return }
        
        let nextIndex = (visibleIndexPath + 1) % schedules.count
        let nextLabel = stackView.arrangedSubviews[nextIndex]
        scrollView.scrollRectToVisible(nextLabel.frame, animated: true)
    }
    
    deinit {
        timer?.invalidate()
    }
}
