//
//  AddFriendViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Foundation

class AddFriendViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searchedMember: Friend?
    @Published var showError: Bool = false
    
    private let memberSearchUseCase: MemberSearchUseCase
    private let postFriendRequestUseCase: PostFriendRequestUseCase
    
    init(memberSearchUseCase: MemberSearchUseCase, postFriendRequestUseCase: PostFriendRequestUseCase) {
        self.memberSearchUseCase = memberSearchUseCase
        self.postFriendRequestUseCase = postFriendRequestUseCase
    }
    
    func searchMember() {
        memberSearchUseCase.execute(memberCode: searchText) { result in
            switch result {
            case .success(let friend):
                self.searchedMember = Friend(memberSeq: friend.memberSeq, profileImage: friend.profileImage ?? "", name: friend.userName, isFavorite: false)
                self.showError = false
                print("회원 검색 완료! 프로필 사진 url: \(String(describing: friend.profileImage))")
            case .failure(let error):
                self.showError = true
                print("회원 검색 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    func postFriendRequest() {
        guard let searchedMember else { return }
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        postFriendRequestUseCase.execute(request: PostFriendRequestBody(memberSeq: memberSeq, friendSeq: searchedMember.memberSeq)) { result in
            switch result {
            case .success:
                print("친구 요청 완료!")
            case .failure(let error):
                print("친구 요청 실패 - \(error.localizedDescription)")
            }
        }
    }
}
