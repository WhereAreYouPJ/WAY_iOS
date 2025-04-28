//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 20.08.24.
//

import SwiftUI
import Kingfisher

// TODO: 검색 쿼리에 해당하는 글씨 색 변경
struct SearchFriendsView: View {
    @ObservedObject var viewModel: SearchFriendsViewModel
    
    @Binding var selectedFriends: [Friend]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
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
            
            SearchBarView(searchText: $viewModel.searchText, onClear: viewModel.clearSearch)
            
            FriendListView(
                viewModel: viewModel.friendsViewModel,
                showToggle: true,
                searchText: viewModel.searchText,
                isSelected: { friend in
                    viewModel.isSelected(friend: friend)
                },
                onToggle: { friend in
                    viewModel.toggleSelection(for: friend)
                }
            )
            
//            FriendsSectionView(title: "즐겨찾기", count: viewModel.favorites.count)
//            ForEach(viewModel.filteredFavorites) { friend in
//                FriendCellWithToggle(
//                    friend: friend,
//                    searchText: viewModel.searchText,
//                    isOn: Binding(
//                        get: { viewModel.isSelected(friend: friend) },
//                        set: { _ in viewModel.toggleSelection(for: friend) }
//                    )
//                )
//            }
//            
//            FriendsSectionView(title: "친구", count: viewModel.favorites.count)
//            ForEach(viewModel.filteredFriends) { friend in
//                FriendCellWithToggle(
//                    friend: friend,
//                    searchText: viewModel.searchText,
//                    isOn: Binding(
//                        get: { viewModel.isSelected(friend: friend) },
//                        set: { _ in viewModel.toggleSelection(for: friend) }
//                    )
//                )
//            }
            
            Spacer()
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
        .onAppear {
            viewModel.friendsViewModel.getFriendsList()
            
            // 친구 목록이 로드된 후에 선택 상태를 설정하도록 Combine 활용
            viewModel.friendsViewModel.$favorites
                .combineLatest(viewModel.friendsViewModel.$friends)
                .sink { favorites, friends in
                    // 선택 상태 초기화
                    viewModel.resetSelection()
                    
                    // 선택된 친구들 처리
                    for selectedFriend in selectedFriends {
                        // 즐겨찾기에서 찾기
                        if let foundInFavorites = favorites.first(where: { $0.memberSeq == selectedFriend.memberSeq }) {
                            viewModel.selectedFavorites.insert(foundInFavorites.id)
                        }
                        // 일반 친구 목록에서 찾기
                        else if let foundInFriends = friends.first(where: { $0.memberSeq == selectedFriend.memberSeq }) {
                            viewModel.selectedFriends.insert(foundInFriends.id)
                        }
                    }
                }
                .store(in: &viewModel.cancellables)
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
        .background(Color.blackF0)
        .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
        .padding(.top, LayoutAdapter.shared.scale(value: 20))
    }
}

struct FriendCellWithToggle: View {
    let friend: Friend
    let searchText: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            KFImage(URL(string: friend.profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
            
//            Text(friend.name)
//                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 17))))
//                .foregroundColor(Color(.black22))
//                .padding(8)
            HighlightedText(
                text: friend.name,
                highlightText: searchText,
                highlightColor: .brandDark
            )
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxToggleStyle())
        }
        .padding(.vertical, LayoutAdapter.shared.scale(value: 6))
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.isEnabled) var isEnabled
    
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }, label: {
            HStack {
                if configuration.isOn {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.brandColor))
                } else {
                    Image(systemName: "circle")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
                
                configuration.label
            }
        })
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
