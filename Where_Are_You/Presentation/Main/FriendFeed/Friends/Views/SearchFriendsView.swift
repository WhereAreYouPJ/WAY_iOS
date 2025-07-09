//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 20.08.24.
//

import SwiftUI
import Kingfisher

struct SearchFriendsView: View {
    @ObservedObject var viewModel: SearchFriendsViewModel
    
    @Binding var selectedFriends: [Friend]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                SearchBarView(searchText: $viewModel.searchText, onClear: viewModel.clearSearch)
                    .padding(.top, LayoutAdapter.shared.scale(value: 16))
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.selectedList) { friend in
                            SelectedFriendsView(friend: friend, isOn: Binding(
                                get: { viewModel.isSelected(friend: friend) },
                                set: { _ in viewModel.removeFromSelection(friend: friend) }
                            ))
                        }
                    }
                }
                .padding(.top, LayoutAdapter.shared.scale(value: 12))
                
                FriendListView(
                    viewModel: viewModel.friendsViewModel,
                    showToggle: true,
                    searchText: viewModel.highlightText,
                    isSelected: { friend in
                        viewModel.isSelected(friend: friend)
                    },
                    onToggle: { friend in
                        viewModel.toggleSelection(for: friend)
                    }
                )
                
                Spacer()
            }
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
            .onAppear {
                viewModel.friendsViewModel.getFriendsList()
                
                viewModel.friendsViewModel.$favorites // 친구 목록이 로드된 후에 선택 상태를 설정하도록 Combine 활용
                    .combineLatest(viewModel.friendsViewModel.$friends)
                    .sink { _, _ in
                        viewModel.resetSelection() // 선택 상태 초기화
                        
                        // 기존 선택된 친구들을 순서대로 다시 추가
                        for selectedFriend in selectedFriends {
                            viewModel.selectedOrder.append(selectedFriend)
                        }
                    }
                    .store(in: &viewModel.cancellables)
            }
        }
    }
}

struct SelectedFriendsView: View {
    let friend: Friend
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            KFImage(URL(string: friend.profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: LayoutAdapter.shared.scale(value: 27), height: LayoutAdapter.shared.scale(value: 27))
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 50)))
            
            Text(friend.name)
                .bodyP4Style(color: .black22)
                .lineLimit(1)
            
            Spacer(minLength: LayoutAdapter.shared.scale(value: 12))
            
            Button(action: {
                isOn = false
            }, label: {
                Image(systemName: "multiply")
                    .foregroundColor(.black66)
            })
        }
        .padding(EdgeInsets(top: 6, leading: 5, bottom: 6, trailing: 10))
        .background(Color.brandHighLight1)
        .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var selectedFriends: [Friend] = []
        @StateObject var viewModel: SearchFriendsViewModel = {
            // 테스트를 위한 간단한 의존성 설정
            let friendRepository = FriendRepository(friendService: FriendService())
            let getFriendUseCase = GetFriendUseCaseImpl(friendRepository: friendRepository)
            
            let memberRepository = MemberRepository(memberService: MemberService())
            let memberDetailsUseCase = MemberDetailsUseCaseImpl(memberRepository: memberRepository)
            
            let friendsViewModel = FriendsViewModel(getFriendUseCase: getFriendUseCase, memberDetailsUseCase: memberDetailsUseCase)
            
            let searchViewModel = SearchFriendsViewModel(
                friendsViewModel: friendsViewModel,
                getFriendUseCase: getFriendUseCase)
            
            // 프리뷰용 더미 데이터 설정
            searchViewModel.setDummyData()
            
            return searchViewModel
        }()
        
        var body: some View {
            SearchFriendsView(
                viewModel: viewModel,
                selectedFriends: $selectedFriends
            )
        }
    }
    
    return PreviewWrapper()
}
