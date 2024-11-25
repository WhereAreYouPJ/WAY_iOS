//
//  FriendDetailView.swift
//  Where_Are_You
//
//  Created by juhee on 19.11.24.
//

import SwiftUI

struct FriendDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: FriendDetailViewModel
    @State private var showOptions = false
    @State private var menuPosition: CGPoint = .zero
    
    var onDelete: (() -> Void)?
    
    var body: some View {
        ZStack {
            Color(.color5).opacity(0.3)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.white)
                            .frame(width: LayoutAdapter.shared.scale(value: 14), height: LayoutAdapter.shared.scale(value: 14))
                    }
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
                            Image(systemName: "ellipsis")
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
                
                Image(viewModel.friend?.profileImage != "" ? "exampleProfileImage" : "defaultImage") // TODO: 추후 실제 프로필사진으로 변경
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: LayoutAdapter.shared.scale(value: 100), height: LayoutAdapter.shared.scale(value: 100))
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                
                Text((viewModel.isMyProfile ? "김주희" : viewModel.friend?.name) ?? "") // TODO: 추후 실제 이름으로 변경
                    .font(Font(UIFont.pretendard(NotoSans: .medium, fontSize: 20)))
                    .foregroundStyle(Color.white)
                    .padding(.top, LayoutAdapter.shared.scale(value: 10))
                    .padding(.bottom, LayoutAdapter.shared.scale(value: 90))
            }
            
            if showOptions {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showOptions = false
                    }
                
                CustomMenuView(
                    isPresented: $showOptions,
                    position: menuPosition
                ) {
                    viewModel.deleteFriend {
                        onDelete?()
                        dismiss()
                    }
                }
            }
        }
    }
}

// CustomOptionButtonView를 포함한 메뉴 뷰
struct CustomMenuView: View {
    @Binding var isPresented: Bool
    let position: CGPoint
    let onDelete: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                CustomOptionButtonViewRepresentable(title: "친구 삭제", action: onDelete)
                    .frame(height: LayoutAdapter.shared.scale(value: 44))
            }
            .frame(width: LayoutAdapter.shared.scale(value: 140))
            .background(Color(.popupButtonColor))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .position(x: min(max(position.x, 70), geometry.size.width - 70),
                      y: position.y)
            .transition(.opacity.combined(with: .scale))
        }
    }
}

// CustomOptionButtonView를 SwiftUI에서 사용하기 위한 래퍼
struct CustomOptionButtonViewRepresentable: UIViewRepresentable {
    let title: String
    let action: () -> Void
    
    func makeUIView(context: Context) -> CustomOptionButtonView {
        let view = CustomOptionButtonView(title: title)
        view.button.addTarget(context.coordinator, action: #selector(Coordinator.buttonTapped), for: .touchUpInside)
        return view
    }
    
    func updateUIView(_ uiView: CustomOptionButtonView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(action: action)
    }
    
    class Coordinator: NSObject {
        let action: () -> Void
        
        init(action: @escaping () -> Void) {
            self.action = action
        }
        
        @objc func buttonTapped() {
            action()
        }
    }
}

#Preview {
    // 친구 프로필 프리뷰
    FriendDetailView(viewModel: FriendDetailViewModel(friend: Friend(memberSeq: 1, profileImage: "", name: "김철수", isFavorite: false), isMyProfile: false))
}

#Preview {
    // 내 프로필 프리뷰
    FriendDetailView(viewModel: FriendDetailViewModel(isMyProfile: true))
}
