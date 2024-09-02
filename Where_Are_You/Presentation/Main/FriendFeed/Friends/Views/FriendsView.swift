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

            FriendsListView(viewModel: viewModel)
        }
    }
}

struct SearchBarView: View {
    @Binding var searchText: String
    let onClear: () -> Void
    
    var body: some View {
        TextField("검색", text: $searchText)
            .padding(7)
            .padding(.horizontal, 25)
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 8)
                    
                    if !searchText.isEmpty {
                        Button(action: onClear) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal)
    }
}

struct FriendsListView: View {
    @ObservedObject var viewModel: FriendsViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                Divider()
                HStack {
                    Text("즐겨찾기")
                    Text("\(viewModel.filteredFavorites.count)")
                    Spacer()
                }
                .padding(.vertical)
                
                ForEach(viewModel.filteredFavorites) { friend in
                    FriendCell(friend: friend, isOn: Binding(
                        get: { viewModel.isSelected(friend: friend) },
                        set: { _ in viewModel.toggleSelection(for: friend) }
                    ))
                }
                
                Divider()
                    .padding(.top, 12)
                HStack {
                    Text("친구")
                    Text("\(viewModel.filteredFriends.count)")
                    Spacer()
                }
                .padding(.vertical)
                
                ForEach(viewModel.filteredFriends) { friend in
                    FriendCell(friend: friend, isOn: Binding(
                        get: { viewModel.isSelected(friend: friend) },
                        set: { _ in viewModel.toggleSelection(for: friend) }
                    ))
                }
            }
            .padding()
        }
    }
}

struct FriendCell: View {
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

#Preview {
    FriendsView()
}
