//
//  DatePickerWindowManager.swift
//  Where_Are_You
//
//  Created by juhee on 29.04.25.
//

import SwiftUI
import UIKit

/// DatePicker 등 모달 컨텐츠를 TabBar 위에 표시하기 위한 오버레이 창 관리자
class DatePickerOverlayManager {
    static let shared = DatePickerOverlayManager()
    
    private var overlayWindow: UIWindow?
    private var hostingController: UIHostingController<AnyView>?
    
    /// DatePicker 또는 다른 모달 컨텐츠를 TabBar 위에 표시
    /// - Parameters:
    ///   - content: 표시할 SwiftUI 뷰
    ///   - backgroundColor: 배경 오버레이 색상 (기본값: 반투명 검정)
    ///   - onDismiss: 창이 닫힐 때 실행할 클로저
    func presentOverContent<Content: View>(
        content: Content,
        backgroundColor: UIColor = UIColor.black.withAlphaComponent(0.3),
        onDismiss: @escaping () -> Void = {}
    ) {
        // 이미 표시된 창이 있으면 먼저 닫기
        dismissOverContent()
        
        // 현재 활성화된 window scene 가져오기
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        // 새 창 생성 및 설정
        let window = UIWindow(windowScene: windowScene)
        window.windowLevel = .alert + 1 // TabBar보다 위에 표시
        window.backgroundColor = backgroundColor
        
        // 호스팅 컨트롤러 생성
        let hostingController = UIHostingController(
            rootView: AnyView(
                content
                    .edgesIgnoringSafeArea(.all)
            )
        )
        hostingController.view.backgroundColor = .clear
        
        // 창과 컨트롤러 저장
        self.overlayWindow = window
        self.hostingController = hostingController
        
        // 창 표시
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        
        // 필요한 경우 창이 닫힐 때 코드를 추가할 수 있음
    }
    
    /// 오버레이 창 닫기
    func dismissOverContent() {
        hostingController = nil
        overlayWindow = nil
    }
}

// MARK: - SwiftUI 확장을 통한 접근 편의성 제공
extension View {
    /// DatePicker를 TabBar 위에 오버레이로 표시하는 수정자
    /// - Parameters:
    ///   - isPresented: DatePicker 표시 상태를 제어하는 바인딩
    ///   - onDismiss: DatePicker가 닫힐 때 실행될 클로저
    ///   - content: DatePicker 컨텐츠를 생성하는 클로저
    /// - Returns: 수정된 뷰
    func datepickerOverlay<Content: View>(
        isPresented: Binding<Bool>,
        onDismiss: @escaping () -> Void = {},
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.onChange(of: isPresented.wrappedValue) { _, newValue in
            if newValue {
                // DatePicker 표시
                DatePickerOverlayManager.shared.presentOverContent(
                    content: content(),
                    onDismiss: onDismiss
                )
            } else {
                // DatePicker 닫기
                DatePickerOverlayManager.shared.dismissOverContent()
            }
        }
    }
}
