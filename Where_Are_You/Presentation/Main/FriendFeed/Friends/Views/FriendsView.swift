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
        // 프리뷰용 더미 데이터 초기화
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            let dummyViewModel = FriendsViewModel(
                getFriendUseCase: GetFriendUseCaseImpl(friendRepository: FriendRepository(friendService: FriendService())),
                memberDetailsUseCase: MemberDetailsUseCaseImpl(memberRepository: MemberRepository(memberService: MemberService()))
            )
            
            // 더미 데이터 설정
            dummyViewModel.setDummyData()
            return dummyViewModel
        }
        
        let friendRepository = FriendRepository(friendService: FriendService())
        let getFriendUseCase = GetFriendUseCaseImpl(friendRepository: friendRepository)
        
        let memberRepository = MemberRepository(memberService: MemberService())
        let memberDetailsUseCase = MemberDetailsUseCaseImpl(memberRepository: memberRepository)
        
        return FriendsViewModel(getFriendUseCase: getFriendUseCase, memberDetailsUseCase: memberDetailsUseCase)
    }()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var showSearchBar: Bool
    @State private var selectedFriend: Friend?
    @State private var showMyProfile = true
    @State private var showFriendDetail = false
    @State private var isMyProfileSelected = false
    @State private var shouldRefreshList = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                if showSearchBar {
                    SearchBarView(searchText: $viewModel.searchText,
                                  onClear: {
                        viewModel.clearSearch()
                        showSearchBar = false
                    })
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 10))
                    .transition(.opacity.combined(with: .move(edge: .top)))
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
            .bodyP3Style(color: .black22)
        }
    }
    
    func myProfileView() -> some View {
        HStack {
            KFImage(URL(string: UserDefaultsManager.shared.getProfileImage()))
                .resizable()
                .scaledToFill()
                .frame(width: LayoutAdapter.shared.scale(value: 56), height: LayoutAdapter.shared.scale(value: 56))
                .background(Color.brandLight)
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
            
            Text(UserDefaultsManager.shared.getUserName() ?? "나")
                .padding(LayoutAdapter.shared.scale(value: 8))
            
            Spacer()
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 10))
    }
}

#Preview {
    FriendsView(showSearchBar: .constant(false))
}
