//
//  NotificationViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 12.01.25.
//

import Foundation

class NotificationViewModel: ObservableObject {
    @Published var invitedSchedules: [Schedule]?
    @Published var friendRequests: [FriendRequest]?
    
    private let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    private let getInvitedListUseCase: GetInvitedListUseCase
    private let postAcceptScheduleUseCase: PostAcceptScheduleUseCase
    private let refuseInvitedScheduleUseCase: RefuseInvitedScheduleUseCase
    
    private let getListForReceiverUseCase: GetListForReceiverUseCase
    private let acceptFriendRequestUseCase: AcceptFriendRequestUseCase
    private let refuseFriendRequestUseCase: RefuseFriendRequestUseCase
    
    private let notificationBadgeViewModel: NotificationBadgeViewModel
    
    init(
        getInvitedListUseCase: GetInvitedListUseCase,
        postAcceptScheduleUseCase: PostAcceptScheduleUseCase,
        refuseInvitedScheduleUseCase: RefuseInvitedScheduleUseCase,
        
        getListForReceiverUseCase: GetListForReceiverUseCase,
        acceptFriendRequestUseCase: AcceptFriendRequestUseCase,
        refuseFriendRequestUseCase: RefuseFriendRequestUseCase,
        
        notificationBadgeViewModel: NotificationBadgeViewModel = .shared
    ) {
        self.getInvitedListUseCase = getInvitedListUseCase
        self.postAcceptScheduleUseCase = postAcceptScheduleUseCase
        self.refuseInvitedScheduleUseCase = refuseInvitedScheduleUseCase
        
        self.getListForReceiverUseCase = getListForReceiverUseCase
        self.acceptFriendRequestUseCase = acceptFriendRequestUseCase
        self.refuseFriendRequestUseCase = refuseFriendRequestUseCase
        
        self.notificationBadgeViewModel = notificationBadgeViewModel
    }
    
    // 알림 목록 조회와 읽음 처리를 함께 수행
    func fetchNotifications() {
        // 두 API 호출이 모두 완료된 후 읽음 처리하기 위한 그룹
        let group = DispatchGroup()
        
        // 일정 초대 조회
        group.enter()
        getInvitedList { success in
            group.leave()
        }
        
        // 친구 요청 조회
        group.enter()
        getFriendRequestList { success in
            group.leave()
        }
        
        // 모든 API 호출이 완료된 후 읽음 처리
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            
            // 조회된 알림 데이터로 읽음 처리
            if let schedules = self.invitedSchedules {
                self.notificationBadgeViewModel.markScheduleInvitationsAsRead(scheduleInvitations: schedules)
            }
            if let requests = self.friendRequests {
                self.notificationBadgeViewModel.markFriendRequestsAsRead(friendRequests: requests)
            }
            
            print("🔔 알림 읽음 처리 완료!")
        }
    }
    
    // MARK: 일정 초대 관련
    func getInvitedList(completion: @escaping (Bool) -> Void) {
        getInvitedListUseCase.execute { [weak self] result in
            guard let self = self else {
                completion(false)
                return
            }
            
            switch result {
            case .success(let list):
                let schedules = convertToSchedules(from: list)
                DispatchQueue.main.async {
                    self.invitedSchedules = schedules
                    print("초대된 일정 \(schedules.count)개 조회 완료!")
                    completion(true)
                }
            case .failure(let error):
                print("초대된 일정 조회 실패 - \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func ecceptSchedule(scheduleSeq: Int) {
        postAcceptScheduleUseCase.execute(request: PostAcceptScheduleBody(scheduleSeq: scheduleSeq, memberSeq: memberSeq)) { result in
            switch result {
            case .success:
                print("일정 \(scheduleSeq) 초대 수락 완료!")
            case .failure(let error):
                print("일정 초대 수락 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    func refuseInvitedSchedule(scheduleSeq: Int) {
        refuseInvitedScheduleUseCase.execute(request: RefuseInvitedScheduleBody(memberSeq: memberSeq, scheduleSeq: scheduleSeq)) { result in
            switch result {
            case .success:
                print("일정 \(scheduleSeq) 초대 거절 완료!")
            case .failure(let error):
                print("일정 초대 거절 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 친구 요청 관련
    func getFriendRequestList(completion: @escaping (Bool) -> Void) {
        getListForReceiverUseCase.execute { [weak self] result in
            guard let self = self else {
                completion(false)
                return
            }
            
            switch result {
            case .success(let list):
                let requests = convertToFriendRequests(from: list)
                
                DispatchQueue.main.async {
                    self.friendRequests = requests
                    print("받은 친구 요청 \(requests.count)개 조회 완료!")
                    completion(true)
                }
            case .failure(let error):
                print("받은 친구 요청 조회 실패 - \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func acceptFriendRequest(friendRequest: FriendRequest) {
        acceptFriendRequestUseCase.execute(request: AcceptFriendRequestBody(friendRequestSeq: friendRequest.friendRequestSeq, memberSeq: memberSeq, senderSeq: friendRequest.friend.memberSeq)) { result in
            switch result {
            case .success:
                print("친구 요청 \(friendRequest.friendRequestSeq) 수락 완료!")
            case .failure(let error):
                print("친구 요청 수락 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    func refuseFriendRequest(friendRequestSeq: Int) {
        refuseFriendRequestUseCase.execute(request: RefuseFriendRequestBody(friendRequestSeq: friendRequestSeq)) { result in
            switch result {
            case .success:
                print("친구 요청 \(friendRequestSeq) 거절 완료!")
            case .failure(let error):
                print("친구 요청 거절 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 형변환
    private func convertToSchedules(from invitedLists: GetInvitedListResponse) -> [Schedule] {
        return invitedLists.compactMap { response -> Schedule? in
            guard let startDate = response.startTime.toDate(from: .serverSimple) else {
                print("Date 변환 실패: \(response.startTime)")
                return nil
            }
            
            return Schedule(
                scheduleSeq: response.scheduleSeq,
                title: response.title,
                startTime: startDate,
                endTime: startDate,
                location: Location(sequence: 0, location: response.location, streetName: "", x: 0, y: 0),
                color: "",
                dDay: response.dDay
            )
        }
    }
    
    private func convertToFriendRequests(from requestedLists: [GetListForReceiverResponse]) -> [FriendRequest] {
        return requestedLists.map { response in
            FriendRequest(
                friendRequestSeq: response.friendRequestSeq,
                createTime: response.createTime.toDate(from: .server) ?? Date.now,
                friend: Friend(
                    memberSeq: response.senderSeq,
                    profileImage: response.profileImage ?? AppConstants.defaultProfileImageUrl,
                    name: response.userName,
                    isFavorite: false,
                    memberCode: response.memberCode
                )
            )
        }
    }
}
