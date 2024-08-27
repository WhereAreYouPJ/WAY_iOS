//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 20.08.24.
//

// TODO: 1. 친구 목록 정렬, 2. 코드 가독성 개선

import SwiftUI

struct FriendsView: View {
    @StateObject private var viewModel = SearchFriendsViewModel()
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

            FriendsListView(viewModel: viewModel)

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
            .padding()
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
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
    @ObservedObject var viewModel: SearchFriendsViewModel
    
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
    struct PreviewWrapper: View {
        @State var selectedFriends: [Friend] = []
        
        var body: some View {
            FriendsView(selectedFriends: $selectedFriends)
        }
    }
    
    return PreviewWrapper()
}
