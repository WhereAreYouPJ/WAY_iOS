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
    
    @Published var showSearchError: Bool = false
    
    @Published var isRequestSuccess: Bool = false
    @Published var errorText: String = ""
    
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
                self.searchedMember = Friend(memberSeq: friend.memberSeq,
                                             profileImage: friend.profileImage ?? AppConstants.ImageAssets.defaultProfileIcon,
                                             name: friend.userName,
                                             isFavorite: false, memberCode: "")
                self.showSearchError = false
                print("회원 검색 완료!")
            case .failure(let error):
                self.showSearchError = true
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
                self.isRequestSuccess = true
                print("친구 요청 완료!")
            case .failure(let error):
                self.isRequestSuccess = false
                if let errorResponse = (error as NSError).userInfo["errorResponse"] as? ErrorResponse {
                    self.errorText = errorResponse.message
                } else {
                    self.errorText = error.localizedDescription
                }
                print("친구 요청 실패 - \(self.errorText)")
            }
        }
    }
}
