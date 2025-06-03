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
            .frame(height: LayoutAdapter.shared.scale(value: 24))
            .padding(LayoutAdapter.shared.scale(value: 7))
            .padding(.horizontal, LayoutAdapter.shared.scale(value: 25))
            .background(Color(.systemGray6))
            .cornerRadius(LayoutAdapter.shared.scale(value: 8))
            .overlay(
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, LayoutAdapter.shared.scale(value: 8))
                    
                    if !searchText.isEmpty {
                        Button(action: onClear) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundStyle(.gray)
                                .padding(.trailing, LayoutAdapter.shared.scale(value: 8))
                        }
                    }
                }
            )
            .padding(.top, LayoutAdapter.shared.scale(value: 10))
    }
}

// MARK: 공통으로 사용할 FriendList 컴포넌트
struct FriendListView: View {
    @ObservedObject var viewModel: FriendsViewModel
    let showToggle: Bool
    var searchText: String = ""
    var isSelected: ((Friend) -> Bool)? = nil  // 선택 상태를 확인하는 클로저
    var onToggle: ((Friend) -> Void)? = nil    // 토글 동작을 처리하는 클로저
    var onFriendSelect: ((Friend) -> Void)? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                FriendsSectionView(title: "즐겨찾기", count: viewModel.filteredFavorites.count)
                ForEach(viewModel.filteredFavorites) { friend in
                    if showToggle {
                        FriendCell(
                            friend: friend,
                            showToggle: true,
                            searchText: searchText,
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
                
                FriendsSectionView(title: "친구", count: viewModel.filteredFriends.count)
                ForEach(viewModel.filteredFriends) { friend in
                    if showToggle {
                        FriendCell(
                            friend: friend,
                            showToggle: true,
                            searchText: searchText,
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
                    .bodyP4Style(color: .blackAC)
                Spacer()
            }
        }
    }
}

// MARK: 친구 셀
struct FriendCell: View {
    let friend: Friend
    var showToggle: Bool = false
    var searchText: String = ""
    var isOn: Binding<Bool>? = nil
    
    var body: some View {
        HStack {
            KFImage(URL(string: friend.profileImage))
                .resizable()
                .scaledToFill()
                .frame(width: LayoutAdapter.shared.scale(value: 56), height: LayoutAdapter.shared.scale(value: 56))
                .background(Color.brandLight)
                .clipShape(RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 14)))
            
            if showToggle {
                HighlightedText(
                    text: friend.name,
                    highlightText: searchText,
                    highlightColor: .brandDark
                )
                .padding(LayoutAdapter.shared.scale(value: 8))
            } else {
                Text(friend.name)
                    .foregroundColor(Color(.black22))
                    .padding(LayoutAdapter.shared.scale(value: 8))
            }
            
            Spacer()
            
            if showToggle, let isOn = isOn {
//                Toggle("", isOn: isOn)
//                    .toggleStyle(CheckboxToggleStyle())
                // 토글 아이콘만 표시, 터치 이벤트는 제거
                if isOn.wrappedValue {
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .foregroundStyle(Color(.brandColor))
                } else {
                    Image(systemName: "circle")
                        .imageScale(.large)
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 10))
        .bodyP3Style(color: .black22)
        .onTapGesture {
            // 토글이 있는 경우 전체 셀 터치 시 토글 상태 변경
            if showToggle, let isOn = isOn {
                isOn.wrappedValue.toggle()
            }
        }
    }
}

// MARK: 에러 발생 시 보여줄 뷰
struct ErrorView: View {
    var retryAction: () -> Void
    
    var body: some View {
        VStack(spacing: LayoutAdapter.shared.scale(value: 16)) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: LayoutAdapter.shared.scale(value: 50)))
                .foregroundColor(.gray)
            Text("친구 목록을 불러오는데 실패했습니다")
                .font(.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 17)))
                .foregroundColor(.gray)
            Button("다시 시도", action: retryAction)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
