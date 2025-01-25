//
//  CommonFriensView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI
import Kingfisher

// MARK: 검색창
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

// MARK: 공통으로 사용할 FriendList 컴포넌트
struct FriendListView: View {
    @ObservedObject var viewModel: FriendsViewModel
    let showToggle: Bool
    var isSelected: ((Friend) -> Bool)? = nil  // 선택 상태를 확인하는 클로저
    var onToggle: ((Friend) -> Void)? = nil    // 토글 동작을 처리하는 클로저
    var onFriendSelect: ((Friend) -> Void)? = nil
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if viewModel.hasError {
                ErrorView {
                    //                    viewModel.retry()
                }
            } else if viewModel.favorites.isEmpty && viewModel.friends.isEmpty {
                EmptyFriendsView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        if !viewModel.filteredFavorites.isEmpty {
                            FriendsSectionView(title: "즐겨찾기", count: viewModel.filteredFavorites.count)
                            ForEach(viewModel.filteredFavorites) { friend in
                                if showToggle {
                                    FriendCell(
                                        friend: friend,
                                        showToggle: true,
                                        isOn: Binding(
                                            get: { isSelected?(friend) ?? false },
                                            set: { _ in onToggle?(friend) }
                                        )
                                    )
                                } else {
                                    FriendCell(friend: friend)
                                        .onTapGesture {
                                            onFriendSelect?(friend)
                                        }
                                }
                            }
                        }
                        
                        if !viewModel.filteredFriends.isEmpty {
                            FriendsSectionView(title: "친구", count: viewModel.filteredFriends.count)
                            ForEach(viewModel.filteredFriends) { friend in
                                if showToggle {
                                    FriendCell(
                                        friend: friend,
                                        showToggle: true,
                                        isOn: Binding(
                                            get: { isSelected?(friend) ?? false },
                                            set: { _ in onToggle?(friend) }
                                        )
                                    )
                                } else {
                                    FriendCell(friend: friend)
                                        .onTapGesture {
                                            onFriendSelect?(friend)
                                        }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: 섹션 구분선
struct FriendsSectionView: View {
    let title: String
    let count: Int
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .padding(.vertical, LayoutAdapter.shared.scale(value: 10))
            
            HStack {
                Text(title)
                Text("\(count)")
                Spacer()
            }
        }
    }
}

// MARK: 친구 셀
struct FriendCell: View {
    let friend: Friend
    var showToggle: Bool = false
    var isOn: Binding<Bool>? = nil
    
    var body: some View {
        HStack {
            KFImage(URL(string: friend.profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            Text(friend.name)
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                .foregroundColor(Color(.black22))
                .padding(8)
            
            Spacer()
            
            if showToggle, let isOn = isOn {
                Toggle("", isOn: isOn)
                    .toggleStyle(CheckboxToggleStyle())
            }
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 10))
    }
}

// MARK: 에러 발생 시 보여줄 뷰
struct ErrorView: View {
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("친구 목록을 불러오는데 실패했습니다")
                .font(.pretendard(NotoSans: .regular, fontSize: 17))
                .foregroundColor(.gray)
            Button("다시 시도", action: retryAction)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: 친구 목록이 비어있을 때 보여줄 뷰
struct EmptyFriendsView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.2")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("아직 등록된 친구가 없습니다")
                .font(.pretendard(NotoSans: .regular, fontSize: 17))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 100)
    }
}
