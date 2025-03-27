//
//  ToastManager.swift
//  Where_Are_You
//
//  Created by juhee on 27.03.25.
//

import SwiftUI
import Combine
import UIKit

class ToastManager: ObservableObject {
    static let shared = ToastManager()
    
    @Published var isPresented = false
    @Published var message = ""
    private var toastWindow: UIWindow?
    private var hostingController: UIHostingController<ToastOverlayView>?
    
    private init() {
        // 토스트 메시지가 사라진 후 창을 숨기기 위한 구독 설정
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        // isPresented가 false로 변할 때 토스트 창을 숨김
        $isPresented
            .dropFirst()
            .filter { !$0 }
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.hideToastWindow()
            }
            .store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    func showToast(message: String) {
        print("ToastManager: 토스트 메시지 표시 - \(message)")
        self.message = message
        
        setupToastWindowIfNeeded()
        
        withAnimation {
            self.isPresented = true
        }
        
        // 2초 후 토스트 메시지 숨기기
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                self.isPresented = false
            }
        }
    }
    
    private func setupToastWindowIfNeeded() {
        // 토스트 창이 아직 설정되지 않았다면 새로 설정
        if toastWindow == nil {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.backgroundColor = .clear
                window.windowLevel = .alert + 1 // 시스템 알림보다 위에 표시
                window.isHidden = false
                
                let overlayView = ToastOverlayView()
                let hostingController = UIHostingController(rootView: overlayView)
                hostingController.view.backgroundColor = .clear
                window.rootViewController = hostingController
                
                self.toastWindow = window
                self.hostingController = hostingController
            }
        } else {
            // 이미 존재하는 창을 표시
            toastWindow?.isHidden = false
        }
    }
    
    private func hideToastWindow() {
        // 토스트가 사라진 후 창을 숨김 (메모리에서 해제하지는 않음)
        toastWindow?.isHidden = true
    }
}

struct ToastOverlayView: View {
    @ObservedObject var toastManager = ToastManager.shared
    
    var body: some View {
        ZStack {
            // 투명 백그라운드
            Color.clear
                .edgesIgnoringSafeArea(.all)
            
            if toastManager.isPresented {
                VStack {
                    Spacer()
                    CustomToast(message: toastManager.message)
                }
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
                .padding(.bottom, LayoutAdapter.shared.scale(value: 20))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
