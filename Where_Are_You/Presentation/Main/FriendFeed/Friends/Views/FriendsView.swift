//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI
import Kingfisher

struct FriendsView: View {
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
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        .onAppear {
            viewModel.getUserDetail()
            viewModel.getFriendsList()
        }
        .fullScreenCover(
            isPresented: $showFriendDetail,
            onDismiss: { viewModel.getFriendsList() },
            content: {
                if isMyProfileSelected {
                    FriendDetailView(viewModel: FriendDetailViewModel(isMyProfile: true))
                } else if let friend = selectedFriend {
                    FriendDetailView(
                        viewModel: FriendDetailViewModel(friend: friend, isMyProfile: false),
                        onDelete: { shouldRefreshList = true }
                    )
                }
            }
        )
    }
    
    func myProfileView() -> some View {
        HStack {
            KFImage(URL(string: UserDefaultsManager.shared.getProfileImage()))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
            
            Text(UserDefaultsManager.shared.getUserName() ?? "유저 이름")
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 17))))
                .foregroundColor(Color(.black22))
                .padding(LayoutAdapter.shared.scale(value: 8))
            
            Spacer()
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 10))
    }
}

#Preview {
    FriendsView(showSearchBar: .constant(false))
}
