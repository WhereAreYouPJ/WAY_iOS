//
//  BottomSheetView.swift
//  Where_Are_You
//
//  Created by 오정석 on 22/1/2025.
//

import UIKit
import SnapKit

class BottomSheetView: UIView {
    // MARK: - Properties
    let sheetHeaderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .brandHighLight1
        return button
    }()
    
    let grabberView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 3
        return view
    }()
    
    let sheetHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandHighLight1
        return view
    }()
    
    let dateTitle = CustomLabel(UILabel_NotoSans: .medium, text: "", textColor: .brandDark, fontSize: 22)
    
    let tableView = UITableView()
    
    lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sheetHeaderView, tableView])
        sv.axis = .vertical
        sv.spacing = LayoutAdapter.shared.scale(value: 8)
        return sv
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        sheetHeaderView.isHidden = true
        tableView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR") // 한국어 포맷
        formatter.dateFormat = "M월 d일" // 원하는 날짜 형식
        return formatter.string(from: Date())
    }
    
    private func configureUI() {
        backgroundColor = .white
        layer.cornerRadius = 15
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        clipsToBounds = true
        dateTitle.text = formattedDate()
        
        addSubview(sheetHeaderButton)
        sheetHeaderButton.addSubview(grabberView)
        sheetHeaderView.addSubview(dateTitle)
        addSubview(contentStackView)

        sheetHeaderButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 30))
        }
        
        grabberView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(LayoutAdapter.shared.scale(value: 133))
            make.height.equalTo(4)
        }
        
        sheetHeaderView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 49))
        }
        
        dateTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(sheetHeaderButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
