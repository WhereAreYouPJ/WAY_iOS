//
//  ManageFriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import SwiftUI
import Kingfisher

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
            ScrollView(.vertical) {
                VStack {
                    requestView(title: "신청한 친구", count: viewModel.sentRequests.count, isSentRequest: true)
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                    
                    Divider()
                        .padding(.vertical, LayoutAdapter.shared.scale(value: 10))
                    
                    requestView(title: "요청이 들어온 친구", count: viewModel.receivedRequests.count, isSentRequest: false)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
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
    }
    
    func requestCellView(isSentRequest: Bool) -> some View {
        VStack {
            ForEach(isSentRequest ? viewModel.sentRequests : viewModel.receivedRequests) { request in
                HStack {
                    KFImage(URL(string: request.friend.profileImage))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(request.friend.name)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                        .foregroundColor(Color(.black22))
                        .padding(LayoutAdapter.shared.scale(value: 8))
                    
                    Spacer()
                    
                    if isSentRequest {
                        CustomButtonSwiftUI(title: "취소", backgroundColor: Color.white, titleColor: Color(.black22)) {
                            viewModel.cancelRequest(requestSeq: request.friendRequestSeq)
                        }
                        .frame(width: LayoutAdapter.shared.scale(value: 90), height: LayoutAdapter.shared.scale(value: 36))
                    } else {
                        buttonMergeView(for: request)
                    }
                }
            }
        }
    }

    func buttonMergeView(for request: FriendRequest) -> some View {
        let state = viewModel.requestStates[request.friendRequestSeq]
        
        return ZStack {
            if state == nil {
                HStack {
                    CustomButtonSwiftUI(title: "수락",
                                      backgroundColor: Color(.brandColor),
                                      titleColor: .white) {
                        withAnimation(.spring(duration: 0.5)) {
                            viewModel.acceptRequest(request: request)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 90),
                          height: LayoutAdapter.shared.scale(value: 36))
                    
                    CustomButtonSwiftUI(title: "거절",
                                      backgroundColor: .white,
                                      titleColor: Color(.black22)) {
                        withAnimation(.spring(duration: 0.5)) {
                            viewModel.refuseRequest(requestSeq: request.friendRequestSeq)
                        }
                    }
                    .frame(width: LayoutAdapter.shared.scale(value: 90),
                          height: LayoutAdapter.shared.scale(value: 36))
                }
            } else {
                Button(action: {}) {
                    HStack {
                        Image(systemName: state == .accepted ? "checkmark" : "xmark")
                            .foregroundColor(state == .accepted ? .white : Color(.black66))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: LayoutAdapter.shared.scale(value: 36))
                    .background(state == .accepted ? Color(.brandColor) : Color.white)
                    .cornerRadius(LayoutAdapter.shared.scale(value: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 12))
                            .stroke(Color(.black66), lineWidth: state == .accepted ? 0 : 1)
                    )
                }
                .frame(width: LayoutAdapter.shared.scale(value: 180))  // 두 버튼의 너비 합
                .transition(.scale)
            }
        }
        .animation(.spring(duration: 0.5), value: state)
    }
}

#Preview {
    ManageFriendsView()
}
