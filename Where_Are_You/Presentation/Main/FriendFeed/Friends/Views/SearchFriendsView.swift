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
            .padding(.horizontal)
            
            SearchBarView(searchText: $viewModel.searchText, onClear: viewModel.clearSearch)
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
            
            FriendListView(
                viewModel: viewModel.friendsViewModel,
                showToggle: true,
                isSelected: { friend in
                    viewModel.isSelected(friend: friend)
                },
                onToggle: { friend in
                    viewModel.toggleSelection(for: friend)
                }
            )
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 16))
        }
        .onAppear {
            viewModel.friendsViewModel.getFriendsList()
            
            // 기존에 선택된 친구들을 viewModel에 반영
            viewModel.resetSelection() // 선택 상태 초기화
            for friend in selectedFriends {
                if !viewModel.isSelected(friend: friend) {
                    viewModel.toggleSelection(for: friend)
                }
            }
        }
    }
}

struct SelectedFriendsView: View {
    let friend: Friend
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            VStack {
//                Image(friend.profileImage)
                KFImage(URL(string: friend.profileImage))
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                    .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
                
                Text(friend.name)
                    .font(.caption)
                    .lineLimit(1)
            }
            Button(action: {
                isOn = false
            }, label: {
                ZStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.white)
                        .opacity(0.8)
                        .shadow(radius: LayoutAdapter.shared.scale(value: 10))
                    Image(systemName: "multiply")
                        .foregroundColor(.gray)
                }
            })
            .offset(x: LayoutAdapter.shared.scale(value: 20), y: LayoutAdapter.shared.scale(value: -28))
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 20))
    }
}

struct FriendCellWithToggle: View {
    let friend: Friend
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            KFImage(URL(string: friend.profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 16)))
            
            Text(friend.name)
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 17))))
                .foregroundColor(Color(.black22))
                .padding(8)
            
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
            
            return SearchFriendsViewModel(
                friendsViewModel: friendsViewModel,
                getFriendUseCase: getFriendUseCase)
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
