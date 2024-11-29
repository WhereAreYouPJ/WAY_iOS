//
//  ManageFriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import SwiftUI

struct ManageFriendsView: View { // TODO: 친구 요청 수락/거절의 경우 체크버튼 전환 애니메이션 필요
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
            ScrollView(.vertical) {
                VStack {
                    requestView(title: "신청한 친구", count: viewModel.sentRequests.count, isSentRequest: true)
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                    
                    Divider()
                        .padding(LayoutAdapter.shared.scale(value: 8))
                    
                    requestView(title: "요청이 들어온 친구", count: viewModel.receivedRequests.count, isSentRequest: false)
                    
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
            .onAppear {
                viewModel.getSentRequests()
                viewModel.getReceivedRequests()
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
        VStack {
            ForEach(isSentRequest ? viewModel.sentRequests : viewModel.receivedRequests) { request in
                HStack {
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
                            viewModel.cancelRequest(requestSeq: request.friendRequestSeq)
                        }
                        .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                    } else {
                        CustomButtonSwiftUI(title: "수락", backgroundColor: Color(.brandColor), titleColor: .white) {
                            viewModel.acceptRequest(request: request)
                        }
                        .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                        
                        CustomButtonSwiftUI(title: "거절", backgroundColor: Color.white, titleColor: Color(.color34)) {
                            viewModel.refuseRequest(requestSeq: request.friendRequestSeq)
                        }
                        .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                    }
                }
            }
        }
    }
}

#Preview {
    ManageFriendsView()
}
