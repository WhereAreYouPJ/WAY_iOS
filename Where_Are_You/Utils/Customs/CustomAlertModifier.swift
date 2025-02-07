//
//  CustomAlertModifier.swift
//  Where_Are_You
//
//  Created by juhee on 07.02.25.
//

import SwiftUI

class OverlayWindow {
    static var alertContainerWindow: UIWindow?
    
    static func show(opacity: CGFloat = 0.3, onTap: @escaping () -> Void, alertView: UIView) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        // 기존 오버레이가 있다면 제거
        hide()
        
        // 딤 효과를 위한 오버레이 뷰
        let overlayView = UIView(frame: window.bounds)
        overlayView.backgroundColor = .black.withAlphaComponent(opacity)
        overlayView.tag = 9999
        
        let tapHandler = OverlayTapHandler(action: onTap)
        let tapGesture = UITapGestureRecognizer(target: tapHandler, action: #selector(OverlayTapHandler.handleTap))
        overlayView.addGestureRecognizer(tapGesture)
        objc_setAssociatedObject(overlayView, "tapHandler", tapHandler, .OBJC_ASSOCIATION_RETAIN)
        
        window.addSubview(overlayView)
        
        // 알림창을 위한 새로운 window 생성
        alertContainerWindow = UIWindow(windowScene: windowScene)
        alertContainerWindow?.windowLevel = .alert // 알림창을 최상위로
        alertContainerWindow?.backgroundColor = .clear
        alertContainerWindow?.rootViewController = UIViewController()
        alertContainerWindow?.rootViewController?.view.backgroundColor = .clear
        alertContainerWindow?.rootViewController?.view.addSubview(alertView)
        alertView.center = alertContainerWindow?.center ?? .zero
        
        alertContainerWindow?.makeKeyAndVisible()
    }
    
    static func hide() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.viewWithTag(9999)?.removeFromSuperview()
        alertContainerWindow?.isHidden = true
        alertContainerWindow = nil
    }
}

// 탭 제스처 핸들러
class OverlayTapHandler: NSObject {
    let action: () -> Void
    
    init(action: @escaping () -> Void) {
        self.action = action
        super.init()
    }
    
    @objc func handleTap() {
        action()
    }
}

struct CustomAlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var showDailySchedule: Bool
    var title: String
    var message: String
    var cancelTitle: String
    var actionTitle: String
    var action: () -> Void
    
    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    // 알림창이 표시될 때 오버레이 표시
                    let alertView = createAlertView()
                    OverlayWindow.show(onTap: {
                        isPresented = false
                    }, alertView: alertView)
                } else {
                    // 알림창이 닫힐 때 오버레이 제거
                    OverlayWindow.hide()
                }
            }
    }
    
    private func createAlertView() -> UIView {
        let alertContent = VStack(spacing: 0) {
            
            VStack(spacing: 0) {
                HStack {
                    Text(title)
                        .font(.pretendard(NotoSans: .bold, fontSize: 18))
                        .foregroundColor(.white)
                        .padding(.bottom, LayoutAdapter.shared.scale(value: 12))
                    
                    Spacer()
                }
                
                HStack {
                    Text(message)
                        .foregroundColor(Color(.color160))
                        .padding(.bottom, LayoutAdapter.shared.scale(value: 24))
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
                HStack(spacing: LayoutAdapter.shared.scale(value: 24)) {
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                        showDailySchedule = true
                    }, label: {
                        Text(cancelTitle)
                            .foregroundColor(.white)
                    })
                    
                    Button(action: {
                        action()
                        isPresented = false
                    }, label: {
                        Text(actionTitle)
                            .foregroundColor(Color(.alertActionButtonColor))
                    })
                }
            }
            .padding(LayoutAdapter.shared.scale(value: 24))
            .frame(width: UIScreen.main.bounds.width - LayoutAdapter.shared.scale(value: 32))
            .background(Color(.color51))
            .cornerRadius(12)
            .font(.pretendard(NotoSans: .medium, fontSize: 14))
            
            Spacer()
                .frame(height: LayoutAdapter.shared.scale(value: 240))
        }
        
        let controller = UIHostingController(rootView: alertContent)
        controller.view.backgroundColor = UIColor.clear
        controller.view.frame = CGRect(x: 0, y: 0,
                                       width: UIScreen.main.bounds.width - LayoutAdapter.shared.scale(value: 56),
                                       height: UIScreen.main.bounds.height / 4)
        
        return controller.view
    }
}

extension View {
    func customAlertModifier(
        isPresented: Binding<Bool>,
        showDailySchedule: Binding<Bool>,
        title: String,
        message: String,
        cancelTitle: String,
        actionTitle: String,
        action: @escaping () -> Void
    ) -> some View {
        self.modifier(CustomAlertModifier(
            isPresented: isPresented,
            showDailySchedule: showDailySchedule,
            title: title,
            message: message,
            cancelTitle: cancelTitle,
            actionTitle: actionTitle,
            action: action
        ))
    }
}

#Preview("Custom Alert") {
   struct PreviewWrapper: View {
       @State private var showAlert = true
       @State private var showDailySchedule = false
       
       var body: some View {
           ZStack {
               // 배경 컨텐츠
               VStack {
                   Text("배경 컨텐츠")
                   Button("Show Alert") {
                       showAlert = true
                   }
               }
               
               // 하단 탭바 시뮬레이션
               VStack {
                   Spacer()
                   HStack {
                       ForEach(0..<4) { i in
                           VStack {
                               Image(systemName: "circle.fill")
                               Text("Tab \(i)")
                           }
                           .frame(maxWidth: .infinity)
                       }
                   }
                   .padding()
                   .background(Color.white)
               }
           }
           .customAlert(
               isPresented: $showAlert,
               showDailySchedule: $showDailySchedule,
               title: "일정 삭제",
               message: "일정을 삭제합니다.\n연관된 피드가 있을 경우 같이 삭제됩니다.",
               cancelTitle: "취소",
               actionTitle: "삭제"
           ) {
               print("Delete action triggered")
           }
       }
   }
   
   return PreviewWrapper()
}

#Preview("Custom Alert - Hidden") {
   struct PreviewWrapper: View {
       @State private var showAlert = false
       @State private var showDailySchedule = false
       
       var body: some View {
           ZStack {
               // 배경 컨텐츠
               VStack {
                   Text("배경 컨텐츠")
                   Button("Show Alert") {
                       showAlert = true
                   }
               }
               
               // 하단 탭바 시뮬레이션
               VStack {
                   Spacer()
                   HStack {
                       ForEach(0..<4) { i in
                           VStack {
                               Image(systemName: "circle.fill")
                               Text("Tab \(i)")
                           }
                           .frame(maxWidth: .infinity)
                       }
                   }
                   .padding()
                   .background(Color.white)
               }
           }
           .customAlert(
               isPresented: $showAlert,
               showDailySchedule: $showDailySchedule,
               title: "일정 삭제",
               message: "일정을 삭제합니다.\n연관된 피드가 있을 경우 같이 삭제됩니다.",
               cancelTitle: "취소",
               actionTitle: "삭제"
           ) {
               print("Delete action triggered")
           }
       }
   }
   
   return PreviewWrapper()
}
