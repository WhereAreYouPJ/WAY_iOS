//
//  ManageFriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import SwiftUI
import Kingfisher

// TODO: 버튼 크기 수정 필요
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
    
    // 더미 데이터 설정 함수
    private func setDummyData() {
        // 일정 초대 더미 데이터
        let calendar = Calendar.current
        let now = Date()
        
        // 친구 요청 더미 데이터
        viewModel.sentRequests = [
            FriendRequest(
                friendRequestSeq: 5001,
                createTime: calendar.date(byAdding: .minute, value: -30, to: now)!,
                friend: Friend(
                    memberSeq: 2001,
                    profileImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3",
                    name: "김지민",
                    isFavorite: false,
                    memberCode: "JIMIN12345"
                )
            ),
            FriendRequest(
                friendRequestSeq: 5002,
                createTime: calendar.date(byAdding: .hour, value: -2, to: now)!,
                friend: Friend(
                    memberSeq: 2002,
                    profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                    name: "이태오",
                    isFavorite: false,
                    memberCode: "TAEO67890"
                )
            )
        ]
        
        // 친구 요청 더미 데이터
        viewModel.receivedRequests = [
            FriendRequest(
                friendRequestSeq: 5003,
                createTime: calendar.date(byAdding: .minute, value: -30, to: now)!,
                friend: Friend(
                    memberSeq: 2003,
                    profileImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3",
                    name: "김지민",
                    isFavorite: false,
                    memberCode: "JIMIN12345"
                )
            ),
            FriendRequest(
                friendRequestSeq: 5004,
                createTime: calendar.date(byAdding: .hour, value: -2, to: now)!,
                friend: Friend(
                    memberSeq: 2004,
                    profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3",
                    name: "이태오",
                    isFavorite: false,
                    memberCode: "TAEO67890"
                )
            )
        ]
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    manageTitleView(title: "친구신청", count: viewModel.sentRequests.count, isSentRequest: true)
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                    
                    Divider()
                        .padding(.vertical, LayoutAdapter.shared.scale(value: 10))
                    
                    manageTitleView(title: "친구요청", count: viewModel.receivedRequests.count, isSentRequest: false)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
            .customNavigationBar(
                title: "친구관리",
                showBackButton: true,
                backButtonAction: {
                    dismiss()
                }
            )
            .onAppear {
                viewModel.getSentRequests()
                viewModel.getReceivedRequests()
//                setDummyData()
            }
        }
    }
    
    func manageTitleView(title: String, count: Int, isSentRequest: Bool) -> some View {
        VStack {
            HStack {
                Text(title)
                    .bodyP3Style(color: .black22)
                
                Text("\(count)")
                    .bodyP3Style(color: .blackAC)
                
                Spacer()
            }
            .padding(.bottom, LayoutAdapter.shared.scale(value: 8))
            
            requestCellView(isSentRequest: isSentRequest)
        }
    }
    
    func requestCellView(isSentRequest: Bool) -> some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 14)) {
            ForEach(isSentRequest ? viewModel.sentRequests : viewModel.receivedRequests) { request in
                HStack {
                    KFImage(URL(string: request.friend.profileImage))
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    
                    Text(request.friend.name)
                        .bodyP3Style(color: .black22)
                        .padding(LayoutAdapter.shared.scale(value: 8))
                    
                    Spacer()
                    
                    if isSentRequest {
                        CustomButtonSwiftUI(
                            title: "삭제",
                            backgroundColor: Color.white,
                            strokeColor: .brandDark,
                            titleColor: .brandDark
                        ) {
                            viewModel.cancelRequest(requestSeq: request.friendRequestSeq)
                        }
                        .frame(width: LayoutAdapter.shared.scale(value: 85), height: LayoutAdapter.shared.scale(value: 38))
                        .button14Style()
                    } else {
                        ButtonMergeView(
                            data: request,
                            acceptButtonTitle: "수락",
                            refuseButtonTitle: "삭제",
                            buttonWidth: 85,
                            buttonHeight: 38,
                            onAccept: { request in
                                viewModel.acceptRequest(request: request)
                                print("친구 수락 버튼 클릭됨!")
                            },
                            onRefuse: { request in
                                viewModel.refuseRequest(requestSeq: request.friendRequestSeq)
                                print("친구 요청 삭제 버튼 클릭됨!")
                            }
                        )
                    }
                } // HStack
                .padding(.horizontal, 2)
            } // ForEach
        } // VStack
    }
}

#Preview {
    ManageFriendsView()
}
