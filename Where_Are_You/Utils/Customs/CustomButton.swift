//
//  CustomButtonView.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2024.
//

import UIKit
import SnapKit

class StandardButton: UIButton {
    init(text: NSAttributedString) {
        super.init(frame: .zero)
        self.setAttributedTitle(text, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Box Button

class TitleButton: UIButton {
    // MARK: - Properties
    private var buttonTitle: NSAttributedString
    private var buttonBackgroundColor: UIColor
    private var borderColor: CGColor?
    private var savedTitle: NSAttributedString?

    private var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    // MARK: - Initializer
    init(title: NSAttributedString, backgroundColor: UIColor, borderColor: CGColor?) {
        self.buttonTitle = title
        self.buttonBackgroundColor = backgroundColor
        self.borderColor = borderColor
        super.init(frame: .zero)
        setupButton()
        setupSpinner()
    }

    // 초기화 시 스피너 추가
    override init(frame: CGRect) {
            // 기본값을 제공하여 초기화
            self.buttonTitle = NSAttributedString(string: "")
            self.buttonBackgroundColor = .clear
            self.borderColor = nil
            super.init(frame: frame)
            setupButton()
            setupSpinner()
    }
    
    required init?(coder: NSCoder) {
        self.buttonTitle = NSAttributedString(string: "")
        self.buttonBackgroundColor = .clear
        self.borderColor = nil
        super.init(coder: coder)
        setupButton()
        setupSpinner()
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        backgroundColor = buttonBackgroundColor
        if borderColor != nil {
            layer.borderColor = borderColor
            layer.borderWidth = 1.5
        }
        titleLabel?.numberOfLines = 0
        setAttributedTitle(buttonTitle, for: .normal)

        // 버튼 모서리 둥글게
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    // MARK: - Public Methods
    func updateTitle(_ text: String) {
        if let currentAttributedTitle = self.attributedTitle(for: .normal) {
            // 현재 attributed title의 첫 번째 문자의 속성을 가져옴 (전체 텍스트에 동일한 속성이 적용되어 있다고 가정)
            let attributes = currentAttributedTitle.attributes(at: 0, effectiveRange: nil)
            let newAttributedTitle = NSAttributedString(string: text, attributes: attributes)
            self.setAttributedTitle(newAttributedTitle, for: .normal)
        } else {
            // 만약 기존의 attributed title이 없다면 기본 설정으로 새 문자열 설정
            self.setTitle(text, for: .normal)
        }
    }
    
    func updateBackgroundColor(_ color: UIColor) {
        self.buttonBackgroundColor = color
        backgroundColor = color
    }
    
    private func setupSpinner() {
        addSubview(spinner)
        // 스피너를 버튼 중앙에 위치시킵니다.
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    /// 로딩 상태 시작: 타이틀을 숨기고 스피너를 시작합니다.
    func showLoading() {
        if let currentTitle = self.attributedTitle(for: .normal) {
            savedTitle = currentTitle
        }
        setTitle("", for: .normal)
        spinner.startAnimating()
    }
    
    /// 로딩 상태 종료: 스피너를 멈추고 원래 타이틀을 복원합니다.
    func hideLoading() {
        spinner.stopAnimating()
        // 저장해둔 타이틀이 있다면 복원, 없으면 기본값으로 설정
        if let restoredTitle = savedTitle {
            self.setAttributedTitle(restoredTitle, for: .normal)
        }
        savedTitle = nil
    }
}

// MARK: - 추가 옵션버튼뷰(여러개)

class MultiCustomOptionsContainerView: UIView {
    private var buttons: [MultiCustomOptionButtonView] = []
    private var actions: [() -> Void] = []
    
    func configureOptions(titles: [String], actions: [() -> Void]) {
        print("Configuring options with titles: \(titles), actions count: \(actions.count)")

        // 기존 버튼 제거
        buttons.forEach { $0.removeFromSuperview() }
        buttons.removeAll()
        self.actions = actions
        
        // 새로운 버튼 추가
        for (index, title) in titles.enumerated() {
            print("Button \(index): \(title) being added to container.") // 추가

            let isLast = index == titles.count - 1
            let buttonView = MultiCustomOptionButtonView(title: title, showSeparator: !isLast)
            addSubview(buttonView)
            buttons.append(buttonView)
            
            buttonView.snp.makeConstraints { make in
                if index == 0 {
                    make.top.equalToSuperview()
                } else {
                    make.top.equalTo(buttons[index - 1].snp.bottom)
                }
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(LayoutAdapter.shared.scale(value: 41))
            }
            
            // 버튼 액션 추가
            buttonView.button.tag = index
            buttonView.button.addAction(UIAction(handler: { [weak self] _ in
                guard let self = self else { return }
                print("Button tapped: \(title), index: \(index)") // 추가
                self.handleButtonTap(index: index)
            }), for: .touchUpInside)
            print("Action added for button with title: \(title) at index: \(index)") // 확인 로그
        }
    
        self.layoutIfNeeded() // 레이아웃 강제 적용

    }
    
    private func handleButtonTap(index: Int) {
        print("Attempting to execute action for button at index: \(index)") // 추가

        guard index >= 0, index < actions.count else {         print("Invalid index: \(index), actions count: \(actions.count)") // 추가

            return }
        actions[index]()
    }
}

class MultiCustomOptionButtonView: UIView {
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .brandDark2
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 176, green: 150, blue: 255) // 구분선 색상
        return view
    }()
    
    init(title: String, showSeparator: Bool = true) {
        super.init(frame: .zero)
        setupView(title: title, showSeparator: showSeparator)
        print("CustomOptionButtonView1 initialized with title: \(title), showSeparator: \(showSeparator)") // 추가
        self.clipsToBounds = false // 부모 뷰가 자식 버튼의 일부를 자르지 않도록 설정
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(title: String, showSeparator: Bool) {
        addSubview(button)
        addSubview(separator)
        
        // 버튼 제목 설정
        let label = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: title, textColor: .white))
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
            make.centerY.equalToSuperview()
        }
        
        // AutoLayout 설정
        button.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 40))
        }
        print("Button frame: \(button.frame)") // 추가

        self.layoutIfNeeded()

        print("Button frame after layout: \(button.frame)")

        separator.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(showSeparator ? 1 : 0) // Separator 보임 여부에 따라 높이 조절
        }
    }
}

// MARK: - 추가 옵션뷰 버튼
class CustomOptionButtonView: UIView {

    let button: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .brandDark2
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 8)
        button.clipsToBounds = true
        return button
    }()

    init(title: String, image: UIImage? = nil) {
        super.init(frame: .zero)
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        createButton(title: title, image: image)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createButton(title: String, image: UIImage? = nil) {
        let label = StandardLabel(UIFont: UIFont.CustomFont.bodyP4(text: title, textColor: .white))
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 12))
        }

        if let image = image {
            let imageView = UIImageView()
            imageView.image = image
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(LayoutAdapter.shared.scale(value: 24))
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            }
        }
    }
}
