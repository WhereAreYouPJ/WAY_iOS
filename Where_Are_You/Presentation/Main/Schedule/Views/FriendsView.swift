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
                viewModel.confirmSelection()
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
    FriendsView()
}


//
//import SwiftUI
//
//struct FriendsView: View {
//    @State private var favorites: [Friend] = [Friend(profileImage: "exampleProfileImage", name: "김친구"),
//                                              Friend(profileImage: "exampleProfileImage", name: "이친구")]
//    @State private var friends: [Friend] = [Friend(profileImage: "exampleProfileImage", name: "박친구"),
//                                            Friend(profileImage: "exampleProfileImage", name: "최친구"),
//                                            Friend(profileImage: "exampleProfileImage", name: "정친구"),
//                                            Friend(profileImage: "exampleProfileImage", name: "김친구")]
//    @State private var selectedFavorites: Set<UUID> = []
//    @State private var selectedFriends: Set<UUID> = []
//    @State private var searchText = ""
//    
//    var filteredFavorites: [Friend] {
//        if searchText.isEmpty {
//            return favorites
//        } else {
//            return favorites.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
//    }
//    
//    var filteredFriends: [Friend] {
//        if searchText.isEmpty {
//            return friends
//        } else {
//            return friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
//        }
//    }
//    
//    var selectedList: [Friend] {
//        favorites.filter { selectedFavorites.contains($0.id) } +
//        friends.filter { selectedFriends.contains($0.id) }
//    }
//    
//    var body: some View {
//        VStack {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack {
//                        ForEach(selectedList) { friend in
//                            SelectedFriendView(friend: friend, isOn: Binding(
//                                get: {
//                                    selectedFavorites.contains(friend.id) || selectedFriends.contains(friend.id)
//                                },
//                                set: { newValue in
//                                    if newValue {
//                                        // 선택 시, 해당 친구가 어느 그룹에 속하는지 확인하고 적절한 Set에 추가
//                                        if favorites.contains(where: { $0.id == friend.id }) {
//                                            selectedFavorites.insert(friend.id)
//                                        } else {
//                                            selectedFriends.insert(friend.id)
//                                        }
//                                    } else {
//                                        // 선택 해제 시, 양쪽 Set에서 모두 제거
//                                        selectedFavorites.remove(friend.id)
//                                        selectedFriends.remove(friend.id)
//                                    }
//                                }
//                            ))
//                        }
//                    }
//                }
//                .padding(.horizontal)
//
//            TextField("검색", text: $searchText)
//                .padding(7)
//                .padding(.horizontal, 25)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
//                .overlay(
//                    HStack {
//                        Image(systemName: "magnifyingglass")
//                            .foregroundColor(.gray)
//                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading, 8)
//                        
//                        if !searchText.isEmpty {
//                            Button(action: {
//                                self.searchText = ""
//                            }) {
//                                Image(systemName: "multiply.circle.fill")
//                                    .foregroundStyle(.gray)
//                                    .padding(.trailing, 8)
//                            }
//                        }
//                    }
//                )
//                .padding(.horizontal)
//            
//            ScrollView {
//                VStack(spacing: 0) {
//                    Divider()
//                    HStack {
//                        Text("즐겨찾기")
//                        Text("\(filteredFavorites.count)")
//                        Spacer()
//                    }
//                    .padding(.vertical)
//                    
//                    ForEach(filteredFavorites) { friend in
//                        FriendCell(friend: friend, isOn: Binding(
//                            get: { selectedFavorites.contains(friend.id) },
//                            set: { newValue in
//                                if newValue {
//                                    selectedFavorites.insert(friend.id)
//                                } else {
//                                    selectedFavorites.remove(friend.id)
//                                }
//                            }
//                        ))
//                    }
//                    
//                    Divider()
//                        .padding(.top, 12)
//                    HStack {
//                        Text("친구")
//                        Text("\(filteredFriends.count)")
//                        Spacer()
//                    }
//                    .padding(.vertical)
//                    
//                    ForEach(filteredFriends) { friend in
//                        FriendCell(friend: friend, isOn: Binding(
//                            get: { selectedFriends.contains(friend.id) },
//                            set: { newValue in
//                                if newValue {
//                                    selectedFriends.insert(friend.id)
//                                } else {
//                                    selectedFriends.remove(friend.id)
//                                }
//                            }
//                        ))
//                    }
//                }
//                .padding()
//            }
//            
//            Button {
//                
//            } label: {
//                Text("확인")
//                    .frame(maxWidth: .infinity)
//            }
//            .buttonStyle(.borderedProminent)
//            .controlSize(.large)
//            .tint(Color(.brandColor))
//            .padding()
//            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
//        }
//    }
//}
//
//struct CheckboxToggleStyle: ToggleStyle {
//    @Environment(\.isEnabled) var isEnabled
//    
//    func makeBody(configuration: Configuration) -> some View {
//        Button(action: {
//            configuration.isOn.toggle()
//        }, label: {
//            HStack {
//                if configuration.isOn {
//                    Image(systemName: "checkmark.circle.fill")
//                        .imageScale(.large)
//                        .foregroundStyle(Color(.brandColor))
//                } else {
//                    Image(systemName: "circle")
//                        .imageScale(.large)
//                        .foregroundStyle(.gray)
//                }
//                
//                configuration.label
//            }
//        })
//    }
//}
//
//struct SelectedFriendView: View {
//    let friend: Friend
//    @Binding var isOn: Bool
//    
//    var body: some View {
//        ZStack {
//            VStack {
//                Image(friend.profileImage)
//                    .resizable()
//                    .scaledToFill()
//                    .frame(width: UIScreen.main.bounds.width * 0.12, height: UIScreen.main.bounds.width * 0.12)
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                
//                Text(friend.name)
//                    .font(.caption)
//                    .lineLimit(1)
//            }
//            Button(action: {
//                isOn = false
//            }) {
//                ZStack {
//                    Image(systemName: "circle.fill")
//                        .foregroundColor(.white)
//                        .opacity(0.8)
//                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                    Image(systemName: "multiply")
//                        .foregroundColor(.gray)
//                }
//            }
//            .offset(x: 20, y: -28)
//        }
//        .padding(.top, 4)
//    }
//}
//
//struct FriendCell: View {
//    let friend: Friend
//    @Binding var isOn: Bool
//    
//    var body: some View {
//        HStack {
//            Image(friend.profileImage)
//                .resizable()
//                .scaledToFill()
//                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
//                .clipShape(RoundedRectangle(cornerRadius: 16))
//            
//            Text(friend.name)
//                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
//                .foregroundColor(Color(.color34))
//                .padding(8)
//            
//            Spacer()
//            
//            Toggle("", isOn: $isOn)
//                .toggleStyle(CheckboxToggleStyle())
//        }
//        .padding(.vertical, 6)
//    }
//}
//
//#Preview {
//    FriendsView()
//}



