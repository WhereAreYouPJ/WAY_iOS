//
//  AnnouncmentCommonView.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/5/2025.
//

import UIKit

class AnnouncmentCommonView: UIView {
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let titleContentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let titleLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP1(text: "t", textColor: .black22))
    
    let dateLabel = StandardLabel(UIFont: UIFont.CustomFont.bodyP5(text: "d", textColor: .blackAC))
    
    lazy var titleStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    
    let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .blackF0
        return view
    }()
    
    let announcmentImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureViewComponents()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureViewComponents() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleContentView)
        contentView.addSubview(borderView)
        contentView.addSubview(announcmentImageView)
        titleContentView.addSubview(titleStack)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
//            make.edges.equalTo(safeAreaLayoutGuide)
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        titleContentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(LayoutAdapter.shared.scale(value: 124))
        }
        
        titleStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 24, basedOnHeight: false))
            make.top.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 20))
        }
        
        borderView.snp.makeConstraints { make in
            make.top.equalTo(titleContentView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        announcmentImageView.snp.makeConstraints { make in
            make.top.equalTo(borderView.snp.bottom)
            make.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    func configure(with title: String, date: String, image: String) {
        titleLabel.updateTextKeepingAttributes(newText: title)
        dateLabel.updateTextKeepingAttributes(newText: date)
        // 지금은 asset에 들어있는 이미지로 사용
        announcmentImageView.image = UIImage(named: image)
    }
}
