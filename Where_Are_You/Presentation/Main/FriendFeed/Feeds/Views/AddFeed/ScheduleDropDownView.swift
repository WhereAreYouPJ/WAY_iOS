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
    
    let chooseScheduleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "일정 선택", textColor: .brandDark))
     
    let scheduleDateLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: "s", textColor: .brandDark))
    
    let scheduleLocationLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP3(text: "s", textColor: .black22))
    
    lazy var scheduleStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [scheduleDateLabel, scheduleLocationLabel])
        sv.axis = .horizontal
        sv.spacing = 0
        return sv
    }()
    
    let dropDownButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .blackAC
        return imageView
    }()
    
    let dropDownTableView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        return tableView
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
        layer.borderWidth = 1.5
        layer.borderColor = UIColor.brandMain.cgColor
        scheduleDateLabel.isHidden = true
        scheduleLocationLabel.isHidden = true
    }

    private func configureViewComponents() {
        addSubview(scheduleDropDownView)
        scheduleDropDownView.addSubview(chooseScheduleLabel)
        scheduleDropDownView.addSubview(dropDownButton)
        scheduleDropDownView.addSubview(scheduleStackView)
        addSubview(dropDownTableView)
    }
    
    private func setupConstraints() {
        scheduleDropDownView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
//            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
        }
        
        dropDownTableView.snp.makeConstraints { make in
            make.top.equalTo(scheduleDropDownView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        chooseScheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.top.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 15))
        }
        
        dropDownButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.centerY.equalToSuperview()
            make.width.equalTo(20)
        }
        
        scheduleDateLabel.snp.makeConstraints { make in
            make.width.equalTo(LayoutAdapter.shared.scale(value: 69))
        }
        
        scheduleStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.trailing.equalTo(dropDownButton.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
}
