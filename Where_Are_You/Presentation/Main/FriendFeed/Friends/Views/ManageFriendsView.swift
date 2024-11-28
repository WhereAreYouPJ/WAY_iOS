//
//  ManageFriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import SwiftUI

struct ManageFriendsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                requestView(title: "신청한 친구", count: 1, isReceivedRequest: false)
                    .padding(.top, LayoutAdapter.shared.scale(value: 16))
                
                Divider()
                    .padding(LayoutAdapter.shared.scale(value: 8))
                
                requestView(title: "요청이 들어온 친구", count: 3, isReceivedRequest: true)
                
                Spacer()
            }
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
            .customNavigationBar(
                title: "친구 추가",
                showBackButton: true,
                backButtonAction: {
                    dismiss()
                }
            )
        }
    }
    
    func requestView(title: String, count: Int, isReceivedRequest: Bool) -> some View {
        VStack {
            HStack {
                Text(title)
                
                Text("\(count)")
                    .foregroundStyle(Color(.color191))
                
                Spacer()
            }
            
            requestCellView(isReceivedRequest: isReceivedRequest)
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
    }
    
    func requestCellView(isReceivedRequest: Bool) -> some View {
        HStack {
            Image("exampleProfileImage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text("김민정")
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                .foregroundColor(Color(.color34))
                .padding(8)
            
            Spacer()
            
            if isReceivedRequest {
                CustomButtonSwiftUI(title: "수락", backgroundColor: Color(.brandColor), titleColor: .white) {
                    print("친구 신청 취소")
                }
                .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
            }
            
            CustomButtonSwiftUI(title: "취소", backgroundColor: Color.white, titleColor: Color(.color34)) {
                print("친구 신청 취소")
            }
            .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
        }
    }
}

#Preview {
    ManageFriendsView()
}
