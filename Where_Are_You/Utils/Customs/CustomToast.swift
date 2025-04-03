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
        VStack {
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 12))
                    .foregroundStyle(Color(.black44))
                    .opacity(0.8)
                    .frame(maxWidth: .infinity)
                    .frame(height: LayoutAdapter.shared.scale(value: 48))
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 40))
                
                Text(message)
                    .bodyP4Style(color: .white)
            }
            .padding(.bottom, LayoutAdapter.shared.scale(value: 20))
        }
    }
}

#Preview {
    CustomToast(message: "신청이 완료되었습니다.")
}
