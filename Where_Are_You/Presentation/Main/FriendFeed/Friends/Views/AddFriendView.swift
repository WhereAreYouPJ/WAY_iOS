//
//  AddFriendView.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI

struct AddFriendView: View { // TODO: 친구 신청 완료시 토스트 팝업
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: AddFriendViewModel = {
        let memberRepository = MemberRepository(memberService: MemberService())
        let memberSearchUseCase = MemberSearchUseCaseImpl(memberRepository: memberRepository)
        
        return AddFriendViewModel(memberSearchUseCase: memberSearchUseCase)
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
                    BottomButtonSwiftUIView(title: "친구 신청하기") {
                        print("친구 신청하기")
                    }
                }
            }
            .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14)))
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
                    .font(.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12)))
                    .padding(.top, LayoutAdapter.shared.scale(value: 12))
                Spacer()
            }
            
            HStack {
                TextField("코드를 입력해주세요.", text: $viewModel.searchText)
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 8))
                    .frame(height: LayoutAdapter.shared.scale(value: 42))
                    .overlay(
                        RoundedRectangle(cornerRadius: LayoutAdapter.shared.scale(value: 6))
                            .stroke(Color(.color212))
                    )
                
                CustomButtonSwiftUI(title: "확인", backgroundColor: Color(.brandColor), titleColor: .white) {
                    viewModel.searchMember()
                }
                .frame(width: LayoutAdapter.shared.scale(value: 100), height: LayoutAdapter.shared.scale(value: 42))
            }
            
            if viewModel.showError {
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
                .fill(Color(.color242))
                .frame(height: LayoutAdapter.shared.scale(value: 158))
            
            VStack {
                Image("exampleProfileImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: LayoutAdapter.shared.scale(value: 100), height: LayoutAdapter.shared.scale(value: 100))
                    .clipShape(RoundedRectangle(cornerRadius: 36))
                
                Text("고윤정")
                    .font(.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 18)))
            }
        }
        .padding(.top, LayoutAdapter.shared.scale(value: 20))
        .padding(.horizontal, LayoutAdapter.shared.scale(value: 20))
    }
}

#Preview {
    AddFriendView()
}
