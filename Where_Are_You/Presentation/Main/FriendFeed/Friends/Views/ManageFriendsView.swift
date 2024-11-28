//
//  ManageFriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import SwiftUI

struct ManageFriendsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: ManageFriendsViewModel = {
        let repository = FriendRequestRepository(friendRequestService: FriendRequestService())
        let getListForSenderUseCase = GetListForSenderUseCaseImpl(repository: repository)
        let getListForReceiverUseCase = GetListForReceiverUseCaseImpl(repository: repository)
        let cancelFriendRequestUseCase = CancelFriendRequestUseCaseImpl(repository: repository)
        let acceptFriendRequestUseCase = AcceptFriendRequestUseCaseImpl(repository: repository)
        let refuseFriendRequestUseCase = RefuseFriendRequestUseCaseImpl(repository: repository)
        
        return ManageFriendsViewModel(
            getListForSenderUseCase: getListForSenderUseCase,
            getListForReceiverUseCase: getListForReceiverUseCase,
            cancelFriendRequestUseCase: cancelFriendRequestUseCase,
            acceptFriendRequestUseCase: acceptFriendRequestUseCase,
            refuseFriendRequestUseCase: refuseFriendRequestUseCase
        )
    }()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    requestView(title: "신청한 친구", count: $viewModel.sentRequests.count, isSentRequest: true)
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                    
                    Divider()
                        .padding(LayoutAdapter.shared.scale(value: 8))
                    
                    requestView(title: "요청이 들어온 친구", count: $viewModel.receivedRequests.count, isSentRequest: false)
                    
                    Spacer()
                }
            }
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
            .customNavigationBar(
                title: "친구 관리",
                showBackButton: true,
                backButtonAction: {
                    dismiss()
                }
            )
            .onAppear() {
                viewModel.getSentRequests()
            }
        }
    }
    
    func requestView(title: String, count: Int, isSentRequest: Bool) -> some View {
        VStack {
            HStack {
                Text(title)
                
                Text("\(count)")
                    .foregroundStyle(Color(.color191))
                
                Spacer()
            }
            
            requestCellView(isSentRequest: isSentRequest)
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
    }
    
    func requestCellView(isSentRequest: Bool) -> some View {
        HStack {
            ForEach(isSentRequest ? viewModel.sentRequests : viewModel.receivedRequests) { request in
                Image(request.friend.profileImage == "" ? "icon-profile-default" : request.friend.profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(request.friend.name)
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                    .foregroundColor(Color(.color34))
                    .padding(8)
                
                Spacer()
                
                if isSentRequest {
                    CustomButtonSwiftUI(title: "취소", backgroundColor: Color.white, titleColor: Color(.color34)) {
                        print("친구 신청 취소")
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                } else {
                    CustomButtonSwiftUI(title: "수락", backgroundColor: Color(.brandColor), titleColor: .white) {
                        print("친구 신청 취소")
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                    
                    CustomButtonSwiftUI(title: "거절", backgroundColor: Color.white, titleColor: Color(.color34)) {
                        print("친구 신청 취소")
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                }
            }
        }
    }
}

#Preview {
    ManageFriendsView()
}
