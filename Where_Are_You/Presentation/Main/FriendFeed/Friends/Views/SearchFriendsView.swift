//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 20.08.24.
//

// TODO: 1. 친구 목록 정렬, 2. 코드 가독성 개선

import SwiftUI

struct SearchFriendsView: View {
    @StateObject private var viewModel: SearchFriendsViewModel = {
        let service = MemberService()
        let repository = MemberRepository(memberService: service)
        let memberDetailsUseCase = MemberDetailsUseCaseImpl(memberRepository: repository)
        let friendsViewModel = FriendsViewModel(memberDetailsUseCase: memberDetailsUseCase)
        return SearchFriendsViewModel(
            friendsViewModel: friendsViewModel,
            memberDetailsUseCase: memberDetailsUseCase)
    }()
    
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
            
            ScrollView {
                VStack(spacing: 0) {
                    FriendsSectionView(title: "즐겨찾기", count: viewModel.filteredFavorites.count)
                    ForEach(viewModel.filteredFavorites) { friend in
                        FriendCell(friend: friend, showToggle: true, isOn: Binding(
                            get: { viewModel.isSelected(friend: friend) },
                            set: { _ in viewModel.toggleSelection(for: friend) }
                        ))
                    }
                    
                    FriendsSectionView(title: "친구", count: viewModel.filteredFriends.count)
                    ForEach(viewModel.filteredFriends) { friend in
                        FriendCell(friend: friend, showToggle: true, isOn: Binding(
                            get: { viewModel.isSelected(friend: friend) },
                            set: { _ in viewModel.toggleSelection(for: friend) }
                        ))
                    }
                }
                .padding()
            }
            
            Button(action: {
                selectedFriends = viewModel.confirmSelection()
                dismiss()
            }) {
                Text("확인")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(Color(.brandColor))
            .padding(.horizontal)
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        }
    }
}

struct SelectedFriendsView: View {
    let friend: Friend
    @Binding var isOn: Bool
    
    var body: some View {
        ZStack {
            VStack {
                Image(friend.profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(friend.name)
                    .font(.caption)
                    .lineLimit(1)
            }
            Button(action: {
                isOn = false
            }) {
                ZStack {
                    Image(systemName: "circle.fill")
                        .foregroundColor(.white)
                        .opacity(0.8)
                        .shadow(radius: 10)
                    Image(systemName: "multiply")
                        .foregroundColor(.gray)
                }
            }
            .offset(x: 20, y: -28)
        }
        .padding(.top, 4)
    }
}

struct FriendCellWithToggle: View {
    let friend: Friend
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            Image(friend.profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(friend.name)
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                .foregroundColor(Color(.color34))
                .padding(8)
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(CheckboxToggleStyle())
        }
        .padding(.vertical, 6)
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
        
        var body: some View {
            SearchFriendsView(selectedFriends: $selectedFriends)
        }
    }
    
    return PreviewWrapper()
}
