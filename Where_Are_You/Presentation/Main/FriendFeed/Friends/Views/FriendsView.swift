//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel:  FriendsViewModel = {
        let service = MemberService()
        let repository = MemberRepository(memberService: service)
        let memberDetailUseCase = MemberDetailsUseCaseImpl(memberRepository: repository)
        return FriendsViewModel(memberDetailsUseCase: memberDetailUseCase)
    }()
    
    @Environment(\.dismiss) private var dismiss
    @Binding var showSearchBar: Bool
    
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
            
            ScrollView {
                VStack(spacing: 0) {
                    MyProfileView()
                    
                    FriendsSectionView(title: "즐겨찾기", count: viewModel.filteredFavorites.count)
                    ForEach(viewModel.filteredFavorites) { friend in
                        FriendCell(friend: friend)
                    }
                    
                    FriendsSectionView(title: "친구", count: viewModel.filteredFriends.count)
                        .padding(.top, 8)
                    ForEach(viewModel.filteredFriends) { friend in
                        FriendCell(friend: friend)
                    }
                }
                .padding()
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
        .padding(.bottom, 14)
    }
}

struct FriendsSectionView: View {
    let title: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            HStack {
                Text(title)
                Text("\(count)")
                Spacer()
            }
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    FriendsView(showSearchBar: .constant(false))
}
