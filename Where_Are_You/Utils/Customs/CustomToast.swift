//
//  CustomToast.swift
//  Where_Are_You
//
//  Created by juhee on 20.01.25.
//

import SwiftUI

struct CustomToast: View {
    let message: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 12))
                .foregroundStyle(Color(.color68))
                .opacity(0.7)
                .frame(width: LayoutAdapter.shared.scale(value: 324), height: LayoutAdapter.shared.scale(value: 48))
            
            Text(message)
                .font(.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.bottom, LayoutAdapter.shared.scale(value: 86))
    }
}

extension View {
    func toast(isPresented: Binding<Bool>, message: String) -> some View {
        self.overlay(
            ZStack {
                if isPresented.wrappedValue {
                    CustomToast(message: message)
                        .transition( // 토스트가 나타나고 사라질 때의 애니메이션을 정의
                            .asymmetric( // 나타날 때와 사라질 때 다른 애니메이션을 적용
                                insertion: .move(edge: .bottom).combined(with: .opacity), // 나타날 때: 아래에서 위로 올라오면서 페이드인
                                removal: .opacity // 사라질 때: 페이드아웃만
                                       )
                        )
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { // 2초 후에
                                withAnimation(.easeInOut(duration: 0.5)) { // 0.3초 동안 부드러운 애니메이션으로
                                    isPresented.wrappedValue = false // 토스트를 사라지게 함
                                }
                            }
                        }
                }
            },
            alignment: .bottom
        )
    }
}

#Preview {
    CustomToast(message: "신청이 완료되었습니다.")
}
