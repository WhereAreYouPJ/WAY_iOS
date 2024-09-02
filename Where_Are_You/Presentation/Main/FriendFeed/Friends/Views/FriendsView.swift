//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel = FriendsViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            SearchBarView(searchText: $viewModel.searchText, onClear: viewModel.clearSearch)
            
            ScrollView {
                VStack(spacing: 0) {
                    FriendsSectionView(title: "즐겨찾기", count: viewModel.filteredFavorites.count)
                    ForEach(viewModel.filteredFavorites) { friend in
                        FriendCell(friend: friend)
                    }
                    
                    FriendsSectionView(title: "친구", count: viewModel.filteredFriends.count)
                    ForEach(viewModel.filteredFriends) { friend in
                        FriendCell(friend: friend)
                    }
                }
                .padding()
            }
        }
    }
}

struct FriendsSectionView: View {
    let title: String
    let count: Int
    
    var body: some View {
        VStack {
            Divider()
            HStack {
                Text(title)
                Text("\(count)")
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    FriendsView()
}
