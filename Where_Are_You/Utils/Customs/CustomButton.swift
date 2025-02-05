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
    let textLabel = UILabel()
    // MARK: - Properties
    private var buttonTitle: NSAttributedString
    private var buttonBackgroundColor: UIColor
    private var borderColor: CGColor?
    
    // MARK: - Initializer
    init(title: NSAttributedString, backgroundColor: UIColor, borderColor: CGColor?) {
        self.buttonTitle = title
        self.buttonBackgroundColor = backgroundColor
        self.borderColor = borderColor
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        backgroundColor = buttonBackgroundColor
        if borderColor != nil {
            layer.borderColor = borderColor
            layer.borderWidth = 1.5
        }
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
                make.height.equalTo(LayoutAdapter.shared.scale(value: 31))
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
        
        // 동적으로 높이 조정
//        self.snp.updateConstraints { make in
//            make.height.equalTo(buttons.count * 44)
//        }
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
        button.backgroundColor = .popupButtonColor
        button.titleLabel?.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 114, green: 98, blue: 168) // 구분선 색상
        return view
    }()
    
    // MARK: - Initializer
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
        let label = UILabel()
        label.text = title
        label.font = UIFont.pretendard(NotoSans: .medium, fontSize: LayoutAdapter.shared.scale(value: 14))
        label.textColor = .white
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 10))
            make.centerY.equalToSuperview()
        }
        
        // AutoLayout 설정
        button.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(LayoutAdapter.shared.scale(value: 30))
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
        button.backgroundColor = .popupButtonColor
        button.layer.cornerRadius = LayoutAdapter.shared.scale(value: 10)
        button.clipsToBounds = true
        return button
    }()

    // MARK: - Initializer
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

    // MARK: - Setup Methods

    private func createButton(title: String, image: UIImage? = nil) {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: LayoutAdapter.shared.scale(value: 14), weight: .medium)
        label.adjustsFontForContentSizeCategory = true
        button.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 14))
        }

        if let image = image {
            let imageView = UIImageView()
            imageView.image = image
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(LayoutAdapter.shared.scale(value: 22))
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 13))
            }
        }
    }
}

// MARK: - 자주 사용하는 하단의 inputcontainer 버튼 한개
class BottomButtonView: UIView {
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .color221
        return view
    }()
    
    var button: CustomButton
    
    init(title: String) {
        self.button = CustomButton(title: title, backgroundColor: .brandColor, titleColor: .color242, font: UIFont.pretendard(NotoSans: .bold, fontSize: LayoutAdapter.shared.scale(value: 18)))
        super.init(frame: .zero)
        backgroundColor = .white
        setupView(title: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(title: String) {
        addSubview(border)
        border.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(1)
        }
        
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(border.snp.bottom).offset(LayoutAdapter.shared.scale(value: 12))
            make.leading.equalToSuperview().offset(LayoutAdapter.shared.scale(value: 15))
            make.height.equalTo(LayoutAdapter.shared.scale(value: 50))
            make.bottom.equalToSuperview().inset(LayoutAdapter.shared.scale(value: 58))
        }
    }
}

// MARK: - Box Button
class CustomButton: UIButton {
    
    // MARK: - Properties
    private var buttonTitle: String
    private var buttonBackgroundColor: UIColor
    private var buttonTitleColor: UIColor
    private var buttonFont: UIFont
    
    // MARK: - Initializer
    init(title: String, backgroundColor: UIColor, titleColor: UIColor, font: UIFont) {
        self.buttonTitle = title
        self.buttonBackgroundColor = backgroundColor
        self.buttonTitleColor = titleColor
        self.buttonFont = font
        super.init(frame: .zero)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Button
    private func setupButton() {
        setTitle(buttonTitle, for: .normal)
        setTitleColor(buttonTitleColor, for: .normal)
        backgroundColor = buttonBackgroundColor
        titleLabel?.font = buttonFont
        
        // 중앙 정렬
        contentHorizontalAlignment = .center
        contentVerticalAlignment = .center
        
        // 버튼 모서리 둥글게
        layer.cornerRadius = LayoutAdapter.shared.scale(value: 6)
        clipsToBounds = true
    }
    
    // MARK: - Public Methods
    func updateTitle(_ title: String) {
        self.buttonTitle = title
        setTitle(buttonTitle, for: .normal)
    }
    
    func updateBackgroundColor(_ color: UIColor) {
        self.buttonBackgroundColor = color
        backgroundColor = color
    }
    
    func updateTitleColor(_ color: UIColor) {
        self.buttonTitleColor = color
        setTitleColor(buttonTitleColor, for: .normal)
    }
    
    func updateFont(_ font: UIFont) {
        self.buttonFont = font
        titleLabel?.font = font
    }
}

// MARK: - Button ONLY Label
class CustomButtonView: UIView {
    
    let button: UIButton
    
    init(text: String, weight: UIFont.Weight, textColor: UIColor, fontSize: CGFloat) {
        self.button = UIButton(type: .system)
        super.init(frame: .zero)
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFontMetrics.default.scaledFont(for: UIFont.pretendard(NotoSans: weight, fontSize: fontSize))
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        addSubview(button)
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
