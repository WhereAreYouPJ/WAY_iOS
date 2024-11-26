//
//  CustomButtonSwiftUI.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI

struct CustomButtonSwiftUI: View {
    // MARK: - Properties
    private let title: String
    private let backgroundColor: Color
    private let titleColor: Color
//    private let font: Font
    private let action: () -> Void
    
    @State private var currentTitle: String
    @State private var currentBackgroundColor: Color
    @State private var currentTitleColor: Color
//    @State private var currentFont: Font
    
    // MARK: - Initializer
    init(
        title: String,
        backgroundColor: Color,
        titleColor: Color,
//        font: Font,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.titleColor = titleColor
//        self.font = font
        self.action = action
        
        // State 초기값 설정
        _currentTitle = State(initialValue: title)
        _currentBackgroundColor = State(initialValue: backgroundColor)
        _currentTitleColor = State(initialValue: titleColor)
//        _currentFont = State(initialValue: font)
    }
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            Text(currentTitle)
//                .font(currentFont)
                .foregroundColor(currentTitleColor)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(currentBackgroundColor)
                .cornerRadius(LayoutAdapter.shared.scale(value: 6))
                .contentShape(Rectangle())
        }
    }
}

struct BottomButtonSwiftUIView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.color221))
                .frame(height: 1)
            
            Button(action: action) {
                Text(title)
                    .font(.custom("Pretendard-Bold", size: LayoutAdapter.shared.scale(value: 18)))
                    .foregroundColor(Color(.color242))
                    .frame(maxWidth: .infinity)
                    .frame(height: LayoutAdapter.shared.scale(value: 50))
                    .background(Color(.brandColor))
                    .cornerRadius(LayoutAdapter.shared.scale(value: 6))
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 15))
            .padding(.top, LayoutAdapter.shared.scale(value: 12))
            .padding(.bottom, LayoutAdapter.shared.scale(value: 24))
        }
        .background(Color.white)
    }
}

struct MultiOptionButtonView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 0.5)) {
            content
        }
        .background(Color(UIColor.systemGray6))
        .cornerRadius(LayoutAdapter.shared.scale(value: 10))
    }
}

struct OptionButton: View {
    let title: String
    let position: ButtonPosition
    let action: () -> Void
    
    enum ButtonPosition {
        case top
        case middle
        case bottom
        case single
        
        var cornerRadius: UIRectCorner {
            switch self {
            case .top: return [.topLeft, .topRight]
            case .bottom: return [.bottomLeft, .bottomRight]
            case .middle: return []
            case .single: return .allCorners
            }
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: LayoutAdapter.shared.scale(value: 14), weight: .medium))
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.leading, LayoutAdapter.shared.scale(value: 14))
            .frame(width: LayoutAdapter.shared.scale(value: 160), height: LayoutAdapter.shared.scale(value: 30))
            .background(Color(.popupButtonColor))
            .clipShape(
                RoundedCorner(radius: LayoutAdapter.shared.scale(value: 10), corners: position.cornerRadius)
            )
        }
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    CustomButtonSwiftUI(
        title: "확인",
        backgroundColor: Color(.brandColor),
        titleColor: .white
//        font: .body
    ) {
        print("커스텀 버튼")
    }
}

#Preview {
    BottomButtonSwiftUIView(title: "버튼 제목") {
        print("버튼 탭됨")
    }
}

#Preview {
    MultiOptionButtonView {
        OptionButton(
            title: "첫 번째 옵션",
            position: .top
        ) {
            print("첫 번째 옵션 선택됨")
        }
        
        OptionButton(
            title: "두 번째 옵션",
            position: .middle
        ) {
            print("두 번째 옵션 선택됨")
        }
        
        OptionButton(
            title: "세 번째 옵션",
            position: .bottom
        ) {
            print("세 번째 옵션 선택됨")
        }
    }
    .padding()
}
