//
//  FriendDetailView.swift
//  Where_Are_You
//
//  Created by juhee on 19.11.24.
//

import SwiftUI
import Kingfisher

struct FriendDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FriendDetailViewModel
    
    @State private var showOptions = false
    @State private var menuPosition: CGPoint = .zero
    @State private var showDeleteAlert = false
    
    var onDelete: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color(.color5).opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.white)
                            .frame(width: LayoutAdapter.shared.scale(value: 14), height: LayoutAdapter.shared.scale(value: 14))
                    })
                    .padding(.leading, LayoutAdapter.shared.scale(value: 25))
                    .padding(.top, LayoutAdapter.shared.scale(value: 16))
                    
                    Spacer()
                    
                    if !viewModel.isMyProfile {
                        // 즐겨찾기 버튼
                        Button(action: {
                            if let isFavorite = viewModel.friend?.isFavorite {
                                if isFavorite {
                                    viewModel.deleteFavoriteFriend {
                                        viewModel.friend?.isFavorite = false
                                    }
                                } else {
                                    viewModel.postFavoriteFriend {
                                        viewModel.friend?.isFavorite = true
                                    }
                                }
                            }
                        }, label: {
                            Image(viewModel.friend?.isFavorite ?? false ? "icon-favorite-filled" : "icon-favorite")
                                .frame(width: LayoutAdapter.shared.scale(value: 14), height: LayoutAdapter.shared.scale(value: 14))
                        })
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                        .padding(.trailing, LayoutAdapter.shared.scale(value: 16))
                        
                        // 더보기 버튼
                        Button(action: {
                            showOptions.toggle()
                        }, label: {
                            Image("icon-3dots")
                                .renderingMode(.template)
                                .foregroundStyle(Color.white)
                                .frame(width: LayoutAdapter.shared.scale(value: 14), height: LayoutAdapter.shared.scale(value: 14))
                        })
                        .padding(.trailing, LayoutAdapter.shared.scale(value: 25))
                        .padding(.top, LayoutAdapter.shared.scale(value: 16))
                        .overlay {
                            GeometryReader { geometry in
                                Color.clear.onAppear {
                                    let frame = geometry.frame(in: .global)
                                    menuPosition = CGPoint(
                                        x: frame.maxX - LayoutAdapter.shared.scale(value: 70),
                                        y: frame.minY - LayoutAdapter.shared.scale(value: -5)
                                    )
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                KFImage(URL(string: viewModel.friend?.profileImage ?? AppConstants.defaultProfileImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: LayoutAdapter.shared.scale(value: 100), height: LayoutAdapter.shared.scale(value: 100))
                    .background(Color.brandLight)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                
                Text((viewModel.isMyProfile ? UserDefaultsManager.shared.getUserName() : viewModel.friend?.name) ?? "이름")
                    .bodyP1Style(color: .white)
                    .padding(.top, LayoutAdapter.shared.scale(value: 10))
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 90))
            }
            
            if showOptions {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showOptions = false
                    }
                
                OptionButtonView {
                    OptionButton(
                        title: "친구 삭제",
                        position: .single,
                        action: {
                            showOptions = false
                            showDeleteAlert = true
                        })
                }
            }
        }
        .customAlert(
            isPresented: $showDeleteAlert,
            showDailySchedule: .constant(false),
            title: "친구 삭제하기",
            message: "친구를 삭제합니다.\n일정에 추가된 경우 자동 삭제처리됩니다.\n삭제된 친구는 친구 추가에서 다시 추가할 수 있습니다.",
            cancelTitle: "취소",
            actionTitle: "삭제",
            action: {
                viewModel.deleteFriend {
                    onDelete?()
                    dismiss()
                }
            }
        )
    }
}

#Preview {
    // 친구 프로필 프리뷰
    FriendDetailView(viewModel: FriendDetailViewModel(friend: Friend(memberSeq: 1, profileImage: "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3", name: "김철수", isFavorite: false, memberCode: "abc12"), isMyProfile: false))
}

#Preview {
    // 내 프로필 프리뷰
    FriendDetailView(viewModel: FriendDetailViewModel(isMyProfile: true))
}
