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
    
    init(memberSearchUseCase: MemberSearchUseCase) {
        self.memberSearchUseCase = memberSearchUseCase
    }
    
    func searchMember() {
        memberSearchUseCase.execute(memberCode: searchText) { result in
            switch result {
            case .success(let friend):
                self.searchedMember = Friend(memberSeq: friend.memberSeq, profileImage: friend.profileImage ?? "", name: friend.userName, isFavorite: false)
                self.showError = false
                print("회원 검색 완료!")
            case .failure(let error):
                self.showError = true
                print("회원 검색 실패 - \(error.localizedDescription)")
            }
        }
    }
}
