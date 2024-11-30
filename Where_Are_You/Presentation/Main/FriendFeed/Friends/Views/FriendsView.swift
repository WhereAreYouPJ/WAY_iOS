//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI

struct FriendsView: View { // TODO: Error getting user: Failed to map data to a Decodable object.
    @StateObject private var viewModel: FriendsViewModel = {
        let friendRepository = FriendRepository(friendService: FriendService())
        let getFriendUseCase = GetFriendUseCaseImpl(friendRepository: friendRepository)
        
        let memberRepository = MemberRepository(memberService: MemberService())
        let memberDetailsUseCase = MemberDetailsUseCaseImpl(memberRepository: memberRepository)
        
        return FriendsViewModel(getFriendUseCase: getFriendUseCase, memberDetailsUseCase: memberDetailsUseCase)
    }()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var showSearchBar: Bool
    @State private var selectedFriend: Friend?
    @State private var showFriendDetail = false
    @State private var isMyProfileSelected = false
    @State private var shouldRefreshList = false
    
    var body: some View {
        VStack(spacing: 0) {
            if showSearchBar {
                SearchBarView(searchText: $viewModel.searchText,
                              onClear: {
                    viewModel.clearSearch()
                    showSearchBar = false
                })
                .transition(.move(edge: .top))
                .animation(.easeInOut, value: showSearchBar)
            }
            
            myProfileView()
                .onTapGesture {
                    isMyProfileSelected = true
                    showFriendDetail = true
                }
            
            FriendListView(
                viewModel: viewModel,
                showToggle: false,
                onFriendSelect: { friend in
                    selectedFriend = friend
                    isMyProfileSelected = false
                    showFriendDetail = true
                }
            )
        }
        .onAppear {
            viewModel.getUserDetail()
            viewModel.getFriendsList()
        }
        .fullScreenCover(isPresented: $showFriendDetail) {
            if shouldRefreshList {
                viewModel.getFriendsList()
                shouldRefreshList = false
            }
        } content: {
            if isMyProfileSelected {
                FriendDetailView(viewModel: FriendDetailViewModel(isMyProfile: true))
            } else if let friend = selectedFriend {
                FriendDetailView(
                    viewModel: FriendDetailViewModel(friend: friend, isMyProfile: false),
                    onDelete: { shouldRefreshList = true }
                )
            }
        }
    }
    
    func myProfileView() -> some View { // TODO: 이미지, 이름 실제 데이터로 변경
        HStack {
            Image("exampleProfileImage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
            
            Text("김주희")
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 17))))
                .foregroundColor(Color(.color34))
                .padding(8)
            
            Spacer()
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 14))
        .padding(.top, LayoutAdapter.shared.scale(value: 10))
    }
}

#Preview {
    FriendsView(showSearchBar: .constant(false))
}
