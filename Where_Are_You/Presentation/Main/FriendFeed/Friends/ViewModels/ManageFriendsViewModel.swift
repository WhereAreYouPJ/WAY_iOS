//
//  ManageFriendsViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 28.11.24.
//

import Foundation

class ManageFriendsViewModel: ObservableObject {
    enum RequestState {
        case canceled
        case accepted
        case rejected
    }
    
    @Published var sentRequests: [FriendRequest] = []
    @Published var receivedRequests: [FriendRequest] = []
    @Published var requestStates: [Int: RequestState] = [:]
    
    private let getListForSenderUseCase: GetListForSenderUseCase
    private let getListForReceiverUseCase: GetListForReceiverUseCase
    private let cancelFriendRequestUseCase: CancelFriendRequestUseCase
    private let acceptFriendRequestUseCase: AcceptFriendRequestUseCase
    private let refuseFriendRequestUseCase: RefuseFriendRequestUseCase
    
    init(getListForSenderUseCase: GetListForSenderUseCase,
         getListForReceiverUseCase: GetListForReceiverUseCase,
         cancelFriendRequestUseCase: CancelFriendRequestUseCase,
         acceptFriendRequestUseCase: AcceptFriendRequestUseCase,
         refuseFriendRequestUseCase: RefuseFriendRequestUseCase) {
        self.getListForSenderUseCase = getListForSenderUseCase
        self.getListForReceiverUseCase = getListForReceiverUseCase
        self.cancelFriendRequestUseCase = cancelFriendRequestUseCase
        self.acceptFriendRequestUseCase = acceptFriendRequestUseCase
        self.refuseFriendRequestUseCase = refuseFriendRequestUseCase
        
        getDummyData()
    }
    
    func getDummyData() {
        sentRequests.append(FriendRequest(friendRequestSeq: 1, createTime: DateFormatter().string(from: Date()), friend: .init(memberSeq: 1, profileImage: "", name: "고윤정", isFavorite: false)))
    }
    
    func getSentRequests() {
        getListForSenderUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let requests):
                    self?.sentRequests = requests.map { response in
                        FriendRequest(friendRequestSeq: response.friendRequestSeq,
                                      createTime: response.createTime,
                                      friend: Friend(memberSeq: response.receiverSeq,
                                                     profileImage: response.profileImage ?? "",
                                                     name: response.userName,
                                                     isFavorite: false)
                        )
                    }
                    print("요청 보낸 목록 조회 성공")
                case .failure(let error):
                    print("요청 보낸 목록 조회 실패 \(error.localizedDescription)")
                }
            }
        }
    }
}
