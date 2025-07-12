//
//  DailyScheduleTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/1/2025.
//

import UIKit

protocol DailyScheduleTableViewCellDelegate: AnyObject {
    func didTapCheckLocationButton(scheduleSeq: Int)
}

class DailyScheduleTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "DailyScheduleTableViewCell"
    weak var delegate: DailyScheduleTableViewCellDelegate?
    
    private var isLocationCheckAvailable = false

    var schedule: SheetSchedule?
    
    private let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP2(text: "96즈 여의도 한강공원 모임", textColor: .black22))
    
    private let locationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "여의도한강공원", textColor: .black66))
    
    private let checkLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "spot3"), for: .normal)
        return button
    }()
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, locationLabel])
        sv.axis = .vertical
        sv.spacing = 2
        return sv
    }()
    
    lazy var stack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [labelStackView, checkLocationButton])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .center // 중요!
        return sv
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        checkLocationButton.isHidden = false
        configureViewComponents()
        setupActions()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {
        contentView.addSubview(stack)
        
        labelStackView.setContentHuggingPriority(.required, for: .vertical)
        labelStackView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    private func setupConstraints() {
        checkLocationButton.snp.makeConstraints { make in
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 42))
        }
        
        stack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupActions() {
        checkLocationButton.addTarget(self, action: #selector(checkLocationButtonTapped), for: .touchUpInside)
    }
    
    func configure(with schedule: SheetSchedule) {
        titleLabel.text = schedule.title
        titleLabel.numberOfLines = 1
        titleLabel.lineBreakMode = .byTruncatingTail

        locationLabel.text = schedule.location
        self.schedule = schedule
        
        if !schedule.isAllday, schedule.isGroup {
            let now = Date()
            let oneHourBefore = Calendar.current.date(byAdding: .hour, value: -1, to: schedule.startTime)!
            
            if now >= oneHourBefore {
                isLocationCheckAvailable = true
                checkLocationButton.isHidden = false
                checkLocationButton.setImage(UIImage(named: "spot3"), for: .normal)
            } else {
                isLocationCheckAvailable = false
                checkLocationButton.isHidden = false
                checkLocationButton.setImage(UIImage(named: "spot3disabled"), for: .normal)
            }
        } else {
            checkLocationButton.isHidden = true
        }
    }
    
    // MARK: - Selectors
    
    @objc func checkLocationButtonTapped() {
        guard let schedule = schedule else { return }
        if isLocationCheckAvailable {
            delegate?.didTapCheckLocationButton(scheduleSeq: schedule.scheduleSeq)
        } else {
            ToastManager.shared.showToast(message: "일정 시작 1시간 전후로 위치 확인이 가능합니다.")
        }
    }
}
