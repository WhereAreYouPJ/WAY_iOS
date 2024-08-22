//
//  ScheduleDropDownView.swift
//  Where_Are_You
//
//  Created by 오정석 on 18/8/2024.
//

import UIKit

class ScheduleDropDown: UIView {
    // MARK: - Properties

    let scheduleDropDownView = UIButton()
    
    let chooseScheduleLabel = CustomLabel(UILabel_NotoSans: .medium, text: "일정 선택", textColor: .color102, fontSize: LayoutAdapter.shared.scale(value: 16))
    
    let scheduleDateLabel: UILabel = {
        let label = UILabel()
        label.text = "2024.04.05"
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 12))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .color68
        label.numberOfLines = 2
        return label
    }()
    
    let scheduleLocationLabel: UILabel = CustomLabel(UILabel_NotoSans: .medium, text: "여의도한강공원", textColor: .color68, fontSize: LayoutAdapter.shared.scale(value: 16))
    
    let dropDownButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .color172
        return imageView
    }()
    
//    let dropDownTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.isHidden = true
//        return tableView
//    }()
    // TODO: 추후 테이블뷰로 변경
    let dropDownTableView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Helpers
    
    private func setupUI() {
        layer.cornerRadius = LayoutAdapter.shared.scale(value: 8)
        layer.borderWidth = 1
        layer.borderColor = UIColor.brandColor.cgColor
        scheduleDateLabel.isHidden = true
        scheduleLocationLabel.isHidden = true
    }

    private func configureViewComponents() {
        addSubview(scheduleDropDownView)
        scheduleDropDownView.addSubview(chooseScheduleLabel)
        scheduleDropDownView.addSubview(dropDownButton)
        scheduleDropDownView.addSubview(scheduleDateLabel)
        scheduleDropDownView.addSubview(scheduleLocationLabel)
        addSubview(dropDownTableView)
    }
    
    private func setupConstraints() {
        scheduleDropDownView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        
        chooseScheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
        }
        
        dropDownButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 18.25))
            make.centerY.equalToSuperview()
        }
        
        scheduleDateLabel.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
        }
        
        scheduleLocationLabel.snp.makeConstraints { make in
            make.leading.equalTo(scheduleDateLabel.snp.trailing)
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.trailing.equalTo(dropDownButton.snp.leading)
        }
        
        dropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(scheduleDropDownView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
