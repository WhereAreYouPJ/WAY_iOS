//
//  FriendsView.swift
//  Where_Are_You
//
//  Created by juhee on 20.08.24.
//

import SwiftUI

struct FriendsView: View {
    @State private var favorites: [Friend] = []
    @State private var friends: [Friend] = []
    @State private var selectedFavorites: Set<UUID> = []
    @State private var selectedFriends: Set<UUID> = []
    @State private var searchText = ""
    
    var filteredFriends: [Friend] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
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
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 0) {
                    Divider()
                    HStack {
                        Text("즐겨찾기")
                        Text("\(favorites.count)")
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    ForEach(favorites) { friend in
                        FriendCell(friend: friend, isOn: Binding(
                            get: { selectedFavorites.contains(friend.id) },
                            set: { newValue in
                                if newValue {
                                    selectedFavorites.insert(friend.id)
                                } else {
                                    selectedFavorites.remove(friend.id)
                                }
                            }
                        ))
                    }
                    
                    Divider()
                        .padding(.top, 12)
                    HStack {
                        Text("친구")
                        Text("\(friends.count)")
                        Spacer()
                    }
                    .padding(.vertical)
                    
                    ForEach(friends) { friend in
                        FriendCell(friend: friend, isOn: Binding(
                            get: { selectedFriends.contains(friend.id) },
                            set: { newValue in
                                if newValue {
                                    selectedFriends.insert(friend.id)
                                } else {
                                    selectedFriends.remove(friend.id)
                                }
                            }
                        ))
                    }
                }
                .padding()
            }
            .onAppear {
                loadFriends()
            }
            
            Button {
                
            } label: {
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
    
    private func loadFriends() {
        favorites = [Friend(profileImage: "exampleProfileImage", name: "김친구"),
                     Friend(profileImage: "exampleProfileImage", name: "이친구")]
        friends = [Friend(profileImage: "exampleProfileImage", name: "박친구"),
                   Friend(profileImage: "exampleProfileImage", name: "최친구"),
                   Friend(profileImage: "exampleProfileImage", name: "저친구")]
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
                        .foregroundColor(Color(.brandColor))
                } else {
                    Image(systemName: "circle")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
                
                configuration.label
            }
        })
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
