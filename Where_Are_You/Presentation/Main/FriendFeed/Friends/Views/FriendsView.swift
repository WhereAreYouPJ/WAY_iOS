//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel: FriendsViewModel = {
        let service = FriendService()
        let repository = FriendRepository(friendService: service)
        let getFriendUseCase = GetFriendUseCaseImpl(friendRepository: repository)
        return FriendsViewModel(getFriendUseCase: getFriendUseCase)
    }()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var showSearchBar: Bool
    @State private var selectedFriend: Friend?
    @State private var showFriendDetail = false
    @State private var isMyProfileSelected = false
    
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
            
            MyProfileView()
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
            viewModel.getFriendsList()
        }
        .fullScreenCover(isPresented: $showFriendDetail) {
            if isMyProfileSelected {
                FriendDetailView(viewModel: FriendDetailViewModel(isMyProfile: true))
            } else if let friend = selectedFriend {
                FriendDetailView(viewModel: FriendDetailViewModel(friend: friend, isMyProfile: false))
            }
        }
    }
}

struct MyProfileView: View {
    var body: some View {
        HStack {
            Image("exampleProfileImage")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text("김주희")
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                .foregroundColor(Color(.color34))
                .padding(8)
            
            Spacer()
        }
        .padding(.horizontal, 14)
    }
}

#Preview {
    FriendsView(showSearchBar: .constant(false))
}
