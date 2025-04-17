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
    
    @Published var disabledButton: Bool = false
    
    private let memberSearchUseCase: MemberSearchUseCase
    private let postFriendRequestUseCase: PostFriendRequestUseCase
    
    init(memberSearchUseCase: MemberSearchUseCase, postFriendRequestUseCase: PostFriendRequestUseCase) {
        self.memberSearchUseCase = memberSearchUseCase
        self.postFriendRequestUseCase = postFriendRequestUseCase
    }
    
    func searchMember() {
        self.disabledButton = false
        
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
        self.disabledButton = true
        
        guard let searchedMember else { return }
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        postFriendRequestUseCase.execute(request: PostFriendRequestBody(memberSeq: memberSeq, friendSeq: searchedMember.memberSeq)) { [weak self] result in
            guard self != nil else { return }
            
            DispatchQueue.main.async {
                var toastMessage = ""
                
                switch result {
                case .success:
                    toastMessage = "친구 신청이 완료되었습니다."
                    print("친구 요청 완료!")
                case .failure(let error):
                    if let errorResponse = (error as NSError).userInfo["errorResponse"] as? ErrorResponse {
                        toastMessage = errorResponse.message
                    } else {
                        toastMessage = error.localizedDescription
                    }
                    print("친구 요청 실패 - \(toastMessage)")
                }
                ToastManager.shared.showToast(message: toastMessage)
            }
        }
    }
}

// FriendsViewModel 클래스에 아래 메서드 추가
extension AddFriendViewModel {
    // 더미 데이터 설정 메서드
    func setDummyData() {
        // 즐겨찾기 친구들
        self.searchedMember = Friend(
            memberSeq: 1,
            profileImage: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3",
            name: "루시",
            isFavorite: false,
            memberCode: "A1B2C3"
        )
    }
}
