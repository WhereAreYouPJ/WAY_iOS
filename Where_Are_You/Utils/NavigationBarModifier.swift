//
//  NavigationBarModifier.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    let title: String
    var showBackButton: Bool = true
    var rightButton: (() -> AnyView)? = nil
    var backButtonAction: (() -> Void)? = nil
    
    init(
        title: String,
        showBackButton: Bool = true,
        rightButton: (() -> AnyView)? = nil,
        backButtonAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.showBackButton = showBackButton
        self.rightButton = rightButton
        self.backButtonAction = backButtonAction
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().tintColor = .white
    }
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .foregroundColor(Color(.color34))
                }
                
                if showBackButton {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            backButtonAction?()
                        }, label: {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(Color(.color172))
                        })
                    }
                }
                
                if let rightButton = rightButton {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        rightButton()
                    }
                }
            }
    }
}

// MARK: - View Extension
extension View {
    func customNavigationBar(
        title: String,
        showBackButton: Bool = true,
        rightButton: (() -> AnyView)? = nil,
        backButtonAction: (() -> Void)? = nil
    ) -> some View {
        self.modifier(NavigationBarModifier(
            title: title,
            showBackButton: showBackButton,
            rightButton: rightButton,
            backButtonAction: backButtonAction
        ))
    }
}

// MARK: - Preview
struct NavigationBarPreview: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Color.white
                .customNavigationBar(
                    title: "네비게이션 타이틀",
                    showBackButton: true,
                    rightButton: {
                        AnyView(
                            Button(action: {
                                print("오른쪽 버튼 탭")
                            }) {
                                Image(systemName: "gear")
                                    .foregroundColor(Color(.color172))
                            }
                        )
                    },
                    backButtonAction: {
                        dismiss()
                    }
                )
        }
    }
}

#Preview {
    NavigationBarPreview()
}
