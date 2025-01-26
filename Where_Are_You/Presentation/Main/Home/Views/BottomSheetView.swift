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
    
    let scrollView = UIScrollView()
    
    let tableView = UITableView()
    
    lazy var contentStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sheetHeaderView, scrollView])
        sv.axis = .vertical
        return sv
    }()
    
    lazy var sheetStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [sheetHeaderButton, contentStackView])
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        dateTitle.text = formattedDate()
        sheetHeaderView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    func showExpandView(isExpand: Bool) {
        contentStackView.isHidden = !isExpand
        sheetHeaderView.isHidden = !isExpand
        tableView.isHidden = !isExpand
        
        sheetStackView.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(isExpand ? LayoutAdapter.shared.scale(value: 420) : LayoutAdapter.shared.scale(value: 30))
        }
        
        // 레이아웃 업데이트
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        }
    }
    
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
        
//        addSubview(dimView)
        addSubview(sheetStackView)
        addSubview(sheetHeaderButton)
        sheetHeaderButton.addSubview(grabberView)
        addSubview(contentStackView)
        scrollView.addSubview(tableView)
        sheetHeaderView.addSubview(dateTitle)
        
        sheetStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalTo(sheetHeaderButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        sheetHeaderView.snp.makeConstraints { make in
            make.height.equalTo(LayoutAdapter.shared.scale(value: 49))
        }
        
        dateTitle.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 8))
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 28))
        }

        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        tableView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//        }
    }
}
