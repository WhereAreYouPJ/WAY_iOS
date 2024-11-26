//
//  CustomButtonSwiftUI.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI

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
