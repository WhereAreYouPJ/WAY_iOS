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
    private let strokeColor: Color
    private let titleColor: Color
    private let titleSize: Int
    private let action: () -> Void
    
    @State private var currentTitle: String
    @State private var currentBackgroundColor: Color
    @State private var currentStrokeColor: Color
    @State private var currentTitleColor: Color
    @State private var currentTitleSize: Int
    
    init(
        title: String,
        backgroundColor: Color,
        strokeColor: Color = .clear,
        titleColor: Color,
        titleSize: Int = 14,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.strokeColor = strokeColor
        self.titleColor = titleColor
        self.titleSize = titleSize
        self.action = action
        
        _currentTitle = State(initialValue: title)
        _currentBackgroundColor = State(initialValue: backgroundColor)
        _currentStrokeColor = State(initialValue: strokeColor)
        _currentTitleColor = State(initialValue: titleColor)
        _currentTitleSize = State(initialValue: titleSize)
    }
    
    var body: some View {
        Button(action: action) {
            Text(currentTitle)
                .foregroundColor(currentTitleColor)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
                .background(currentBackgroundColor)
                .cornerRadius(LayoutAdapter.shared.scale(value: 6))
                .contentShape(Rectangle())
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 6))
//                        .stroke(backgroundColor == .white ? Color(.color153) : .clear)
                        .stroke(strokeColor, style: StrokeStyle(lineWidth: 1.5))
                )
        }
    }
}

struct BottomButtonSwiftUIView: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(Color(.color221))
                .frame(height: 1)
            
            Button(action: action) {
                Text(title)
                    .foregroundColor(Color(.color242))
                    .frame(maxWidth: .infinity)
                    .frame(height: LayoutAdapter.shared.scale(value: 50))
                    .background(background)
                    .cornerRadius(LayoutAdapter.shared.scale(value: 6))
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 15))
            .padding(.top, LayoutAdapter.shared.scale(value: 12))
            .padding(.bottom, LayoutAdapter.shared.scale(value: 24))
        }
        .background(Color.white)
    }
}

struct OptionButtonView<Content: View>: View {
    let content: Content
    let topPadding: CGFloat
    
    init(topPadding: CGFloat = 48, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.topPadding = topPadding
    }
    
    var body: some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 0.5)) {
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        .padding(EdgeInsets(top: topPadding, leading: 0, bottom: 0, trailing: 24))
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
                    .bodyP4Style(color: .white)
                
                Spacer()
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 12))
            .frame(width: LayoutAdapter.shared.scale(value: 155), height: LayoutAdapter.shared.scale(value: 40))
            .background(Color(.brandDark2))
            .clipShape(
                RoundedCorner(radius: LayoutAdapter.shared.scale(value: 8), corners: position.cornerRadius)
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

#Preview("커스텀 버튼") {
    CustomButtonSwiftUI(
        title: "확인",
        backgroundColor: Color(.brandColor),
        titleColor: .white,
        titleSize: 16
    ) {
        print("커스텀 버튼")
    }
}

#Preview("하단 버튼") {
    BottomButtonSwiftUIView(title: "버튼 제목", background: Color(.brandColor)) {
        print("버튼 탭됨")
    }
}

#Preview("다중 옵션 메뉴") {
    OptionButtonView {
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

#Preview("단일 옵션 메뉴") {
    OptionButton(
        title: "옵션 한 개",
        position: .single
    ) {
        print("옵션 선택됨")
    }
}
