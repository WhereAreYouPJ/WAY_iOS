//
//  CustomAlert_SwiftUI.swift
//  Where_Are_You
//
//  Created by juhee on 13.10.24.
//

import SwiftUI

struct CustomAlertSwiftUI: View {
    @Binding var isPresented: Bool
    @Binding var showDailySchedule: Bool
    let title: String
    let message: String
    let cancelTitle: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }
            
            VStack {
                Spacer()
                    .frame(height: LayoutAdapter.shared.scale(value: 160))
                
                VStack(spacing: 0) {
                    HStack {
                        Text(title)
                            .titleH1Style(color: .white)
                            .padding(.bottom, LayoutAdapter.shared.scale(value: 12))
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text(message)
                            .bodyP4Style(color: .blackD4)
                            .padding(.bottom, LayoutAdapter.shared.scale(value: 24))
                        
                        Spacer()
                    }
                    
                    HStack(spacing: LayoutAdapter.shared.scale(value: 24)) {
                        Spacer()
                        
                        Button(action: {
                            isPresented = false
                            showDailySchedule = true
                        }, label: {
                            Text(cancelTitle)
                                .bodyP4Style(color: .white)
                        })
                        
                        Button(action: {
                            action()
                            isPresented = false
                        }, label: {
                            Text(actionTitle)
                                .bodyP4Style(color: .secondaryDark)
                        })
                    }
                }
                .padding(LayoutAdapter.shared.scale(value: 24))
                .frame(width: UIScreen.main.bounds.width - LayoutAdapter.shared.scale(value: 32))
                .background(Color(.color51))
                .cornerRadius(12)
                .font(.pretendard(NotoSans: .medium, fontSize: 14))
                
                Spacer()
            }
        }
    }
}

extension View {
    func customAlert(isPresented: Binding<Bool>, showDailySchedule: Binding<Bool>, title: String, message: String, cancelTitle: String, actionTitle: String, action: @escaping () -> Void) -> some View {
        ZStack {
            self
            if isPresented.wrappedValue {
                CustomAlertSwiftUI(isPresented: isPresented, showDailySchedule: showDailySchedule, title: title, message: message, cancelTitle: cancelTitle, actionTitle: actionTitle, action: action)
            }
        }
    }
}

// Preview
#Preview {
    CustomAlertSwiftUI(isPresented: .constant(true), showDailySchedule: .constant(false),
                       title: "알림",
                       message: "이것은 커스텀 알림입니다.\n여러 줄 메시지도 가능합니다.",
                       cancelTitle: "취소",
                       actionTitle: "확인") {
        print("확인 버튼이 눌렸습니다.")
    }
}
