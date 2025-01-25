//
//  DailyScheduleTableViewCell.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/1/2025.
//

import UIKit

protocol DailyScheduleTableViewCellDelegate: AnyObject {
    func didTapCheckLocationButton(schedule: Schedule)
}

class DailyScheduleTableViewCell: UITableViewCell {
    // MARK: - Properties

    static let identifier = "DailyScheduleTableViewCell"
    weak var delegate: DailyScheduleTableViewCellDelegate?

    var schedule: Schedule?
    
    private let titleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "96즈 여의도 한강공원 모임", textColor: .black44, fontSize: 18)
    
    private let locationLabel = CustomLabel(UILabel_NotoSans: .medium, text: "여의도한강공원", textColor: .color153, fontSize: 14)
    
    private let checkLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "spot3"), for: .normal)
        return button
    }()
    
    lazy var labelStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, locationLabel])
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViewComponents()
        setupActions()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func configureViewComponents() {
        contentView.addSubview(labelStackView)
        contentView.addSubview(checkLocationButton)
    }
    
    private func setupConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
            make.centerY.equalToSuperview()
        }
        
        checkLocationButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
            make.width.height.equalTo(LayoutAdapter.shared.scale(value: 42))
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupActions() {
        checkLocationButton.addTarget(self, action: #selector(checkLocationButtonTapped), for: .touchUpInside)
    }
    
    func configure(with schedule: Schedule) {
        titleLabel.text = schedule.title
        locationLabel.text = schedule.location?.location
        self.schedule = schedule
    }
    
    // MARK: - Selectors
    
    @objc func checkLocationButtonTapped() {
        guard let schedule = schedule else { return }
        
        delegate?.didTapCheckLocationButton(schedule: schedule)
    }
}
