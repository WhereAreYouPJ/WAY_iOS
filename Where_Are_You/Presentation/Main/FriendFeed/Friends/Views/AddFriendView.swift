//
//  AddFriendView.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI
import Kingfisher

struct AddFriendView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddFriendViewModel = {
        // 프리뷰용 더미 데이터 설정
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            let dummyViewModel = AddFriendViewModel(
                memberSearchUseCase: MemberSearchUseCaseImpl(memberRepository: MemberRepository(memberService: MemberService())),
                postFriendRequestUseCase: PostFriendRequestUseCaseImpl(repository: FriendRequestRepository(friendRequestService: FriendRequestService()))
            )
            
            dummyViewModel.setDummyData()
            return dummyViewModel
        }
        
        let memberRepository = MemberRepository(memberService: MemberService())
        let memberSearchUseCase = MemberSearchUseCaseImpl(memberRepository: memberRepository)
        
        let friendRequestRepository = FriendRequestRepository(friendRequestService: FriendRequestService())
        let postFriendRequestUseCase = PostFriendRequestUseCaseImpl(repository: friendRequestRepository)
        
        return AddFriendViewModel(memberSearchUseCase: memberSearchUseCase,
                                  postFriendRequestUseCase: postFriendRequestUseCase)
    }()
    
    var body: some View {
        NavigationStack {
            VStack {
                searchCodeView()
                
                if viewModel.searchedMember != nil {
                    profileCheckView()
                }
                
                Spacer()
                
                if viewModel.searchedMember != nil {
                    let background = viewModel.disabledButton ? Color(.color171) : Color(.brandColor)
                    BottomButtonSwiftUIView(title: "친구 신청하기", background: background) {
                        viewModel.postFriendRequest()
                    }
                    .button18Style()
                    .disabled(viewModel.disabledButton)
                }
            }
            .customNavigationBar(
                title: "친구 추가",
                showBackButton: true,
                backButtonAction: {
                    dismiss()
                }
            )
        }
    }
    
    func searchCodeView() -> some View {
        VStack {
            HStack {
                Text("코드 검색")
                    .bodyP5Style(color: .black22)
                    .padding(.top, LayoutAdapter.shared.scale(value: 12))
                Spacer()
            }
            
            HStack(spacing: LayoutAdapter.shared.scale(value: 8)) {
                TextField(
                    "",
                    text: $viewModel.searchText,
                    prompt: Text("코드를 입력해주세요.")
                        .withBodyP4Style(color: .blackAC)
                )
                .bodyP4Style(color: .black22)
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 8))
                .frame(height: LayoutAdapter.shared.scale(value: 44))
                .overlay(
                    RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 6))
                        .stroke(Color(.color212))
                )
                
                CustomButtonSwiftUI(title: "검색", backgroundColor: Color(.brandColor), titleColor: .white) {
                    viewModel.searchMember()
                }
                .frame(width: LayoutAdapter.shared.scale(value: 91), height: LayoutAdapter.shared.scale(value: 44))
                .button16Style()
            }
            
            if viewModel.showSearchError {
                HStack {
                    Text("코드를 다시 한번 확인해 주세요.")
                        .foregroundStyle(Color.red)
                        .font(.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12)))
                    Spacer()
                }
            }
        }
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
    }
    
    func profileCheckView() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 10))
                .fill(Color(.brandHighLight2))
                .frame(height: LayoutAdapter.shared.scale(value: 153))
            
            VStack {
                KFImage(URL(string: viewModel.searchedMember?.profileImage ?? AppConstants.defaultProfileImageUrl))
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: LayoutAdapter.shared.scale(value: 84), height: LayoutAdapter.shared.scale(value: 84))
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                
                Text(viewModel.searchedMember?.name ?? "")
                    .bodyP2Style(color: .black22)
            }
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 20))
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
    }
}

#Preview {
    AddFriendView()
}
