//
//  NotificationBadgeViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 22.02.25.
//

import Foundation
import SwiftUI

extension Notification.Name {
    static let unreadNotificationsChanged = Notification.Name("unreadNotificationsChanged")
}

// MARK: 1. 읽지 않은 알림 상태(hasUnreadNotifications) 관리
// MARK: 2. 새로운 알림 확인을 위한 API 호출과 상태 업데이트
class NotificationBadgeViewModel: ObservableObject {
    @AppStorage("hasUnreadNotifications") var hasUnreadNotifications: Bool = false { // UserDefaults에 직접 바인딩되는 프로퍼티
        didSet {
            NotificationCenter.default.post( // 상태가 변경될 때 Notification 발송
                name: .unreadNotificationsChanged,
                object: nil,
                userInfo: ["hasUnread": hasUnreadNotifications]
            )
        }
}
    
    private let storage = NotificationStorage.shared
    
    private let getInvitedListUseCase: GetInvitedListUseCase
    private let getListForReceiverUseCase: GetListForReceiverUseCase
    
    static let shared: NotificationBadgeViewModel = {
        let scheduleRepo = ScheduleRepository(scheduleService: ScheduleService())
        let getInvitedListUseCase = GetInvitedListUseCaseImpl(scheduleRepository: scheduleRepo)
        
        let friendRequestRepo = FriendRequestRepository(friendRequestService: FriendRequestService())
        let getListForReceiverUseCase = GetListForReceiverUseCaseImpl(repository: friendRequestRepo)
        
        return NotificationBadgeViewModel(
            getInvitedListUseCase: getInvitedListUseCase,
            getListForReceiverUseCase: getListForReceiverUseCase
        )
    }()
    
    init(
        getInvitedListUseCase: GetInvitedListUseCase,
        getListForReceiverUseCase: GetListForReceiverUseCase
    ) {
        self.getInvitedListUseCase = getInvitedListUseCase
        self.getListForReceiverUseCase = getListForReceiverUseCase
    }
    
    // MARK: 새로운 알림을 확인
    func checkForNewNotifications() {
        let group = DispatchGroup()
        
        var fetchedSchedules: [Schedule] = []
        var fetchedRequests: [FriendRequest] = []
        
        group.enter() // 일정 초대 조회
        getInvitedListUseCase.execute { [weak self] result in
            defer { group.leave() }
            guard let self = self else { return }
            
            switch result {
            case .success(let scheduleInvitations):
                fetchedSchedules = self.convertToSchedules(from: scheduleInvitations)
            case .failure(let error):
                print("일정 초대 조회 실패: \(error)")
            }
        }
        
        group.enter() // 친구 요청 조회
        getListForReceiverUseCase.execute { [weak self] result in
            defer { group.leave() }
            guard let self = self else { return }
            
            switch result {
            case .success(let friendRequests):
                fetchedRequests = self.convertToFriendRequests(from: friendRequests)
            case .failure(let error):
                print("친구 요청 조회 실패: \(error)")
            }
        }
        
        group.notify(queue: .main) { [weak self] in // 두 API 호출이 모두 완료된 후 새로운 알림 확인
            guard let self = self else { return }
            
            let hasNew = self.storage.hasNewNotifications( // NotificationStorage의 메소드를 이용해 새 알림 확인
                scheduleInvites: fetchedSchedules,
                friendRequests: fetchedRequests
            )
            if hasNew {
                self.hasUnreadNotifications = true // @AppStorage 변수에 직접 할당
                print("🔔 새로운 알림이 있습니다.")
            }
        }
    }
    
    // MARK: 알림 읽음 처리 - NotificationViewModel에서 사용
    func markAllAsRead(notificationIds: [String]) {
        storage.saveAllNotificationIds(notificationIds: notificationIds)
        DispatchQueue.main.async {
            self.hasUnreadNotifications = false
        }
    }
    
    // MARK: 일정 초대 or 친구 신청 수락/거절 시 로컬 저장소에서 알림 삭제
    func removeScheduleInvitation(scheduleSeq: Int) {
        storage.removeScheduleInvitation(scheduleSeq: scheduleSeq)
    }

    func removeFriendRequest(friendRequestSeq: Int) {
        storage.removeFriendRequest(friendRequestSeq: friendRequestSeq)
    }
    
    // 형변환
    private func convertToSchedules(from scheduleInvitations: GetInvitedListResponse) -> [Schedule] {
        return scheduleInvitations.compactMap { response -> Schedule? in
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
    
    private func convertToFriendRequests(from friendRequests: [GetListForReceiverResponse]) -> [FriendRequest] {
        return friendRequests.map { response in
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
