//
//  CustomAlert_SwiftUI.swift
//  Where_Are_You
//
//  Created by juhee on 13.10.24.
//

import SwiftUI

struct CustomAlertSwiftUI: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let cancelTitle: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
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
                    
                    Spacer()
                }
                
                HStack(spacing: LayoutAdapter.shared.scale(value: 24)) {
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Text(cancelTitle)
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        action()
                        isPresented = false
                    }) {
                        Text(actionTitle)
                            .foregroundColor(Color(.alertActionButtonColor))
                    }
                }
            }
            .padding(LayoutAdapter.shared.scale(value: 24))
            .frame(width: UIScreen.main.bounds.width - LayoutAdapter.shared.scale(value: 32))
            .background(Color(.color51))
            .cornerRadius(12)
            .font(.pretendard(NotoSans: .medium, fontSize: 14))
        }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, title: String, message: String, cancelTitle: String, actionTitle: String, action: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                CustomAlertSwiftUI(isPresented: isPresented, title: title, message: message, cancelTitle: cancelTitle, actionTitle: actionTitle, action: action)
            }
        }
    }
}

// Preview
#Preview {
    CustomAlertSwiftUI(isPresented: .constant(true),
                       title: "알림",
                       message: "이것은 커스텀 알림입니다.\n여러 줄 메시지도 가능합니다.",
                       cancelTitle: "취소",
                       actionTitle: "확인") {
        print("확인 버튼이 눌렸습니다.")
    }
}
