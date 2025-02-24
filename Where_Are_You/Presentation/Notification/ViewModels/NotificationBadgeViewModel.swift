//
//  NotificationBadgeViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 22.02.25.
//

import Foundation

// TODO: 확인한 알림 삭제
class NotificationBadgeViewModel: ObservableObject {
    @Published var hasUnreadNotifications: Bool = false
    private let storage: NotificationStorage
    
    private let getInvitedListUseCase: GetInvitedListUseCase
    private let getListForReceiverUseCase: GetListForReceiverUseCase
    
    static let shared: NotificationBadgeViewModel = {
        let scheduleRepo = ScheduleRepository(scheduleService: ScheduleService())
        let getInvitedListUseCase = GetInvitedListUseCaseImpl(scheduleRepository: scheduleRepo)
        
        let friendRequestRepo = FriendRequestRepository(friendRequestService: FriendRequestService())
        let getListForReceiverUseCase = GetListForReceiverUseCaseImpl(repository: friendRequestRepo)
        
        return NotificationBadgeViewModel(
            storage: NotificationStorage(),
            getInvitedListUseCase: getInvitedListUseCase,
            getListForReceiverUseCase: getListForReceiverUseCase
        )
    }()
    
    init(
        storage: NotificationStorage,
        getInvitedListUseCase: GetInvitedListUseCase,
        getListForReceiverUseCase: GetListForReceiverUseCase
    ) {
        self.storage = storage
        self.getInvitedListUseCase = getInvitedListUseCase
        self.getListForReceiverUseCase = getListForReceiverUseCase
    }
    
    // MARK: 알림 읽음 처리 - NotificationViewModel에서 사용
    func markScheduleInvitationsAsRead(scheduleInvitations: [Schedule]) {
        storage.saveScheduleInvitations(scheduleInvitations: scheduleInvitations)
        DispatchQueue.main.async {
            self.hasUnreadNotifications = false
        }
    }
    
    func markFriendRequestsAsRead(friendRequests: [FriendRequest]) {
        storage.saveFriendRequests(friendRequests: friendRequests)
        DispatchQueue.main.async {
            self.hasUnreadNotifications = false
        }
    }
    
    // MARK: 새로운 알림을 로컬 저장소에 저장
    func fetchNotifications() {
        fetchScheduleInvitations()
        fetchFriendRequests()
    }
    
    private func fetchScheduleInvitations() {
        getInvitedListUseCase.execute { [weak self] result in
            switch result {
            case .success(let scheduleInvitations):
                guard let schedules = self?.convertToSchedules(from: scheduleInvitations) else { return }
                self?.checkNewScheduleInvitations(scheduleInvitations: schedules)
            case .failure(let error):
                print("일정 초대 조회 실패: \(error)")
            }
        }
    }
    
    private func fetchFriendRequests() {
        getListForReceiverUseCase.execute { [weak self] result in
            switch result {
            case .success(let friendRequests):
                guard let requests = self?.convertToFriendRequests(from: friendRequests) else { return }
                self?.checkNewFriendRequests(friendRequests: requests)
            case .failure(let error):
                print("친구 요청 조회 실패: \(error)")
            }
        }
    }
    
    private func checkNewScheduleInvitations(scheduleInvitations: [Schedule]) {
        let currentIds = storage.savedNotificationIds
        let hasNew = scheduleInvitations.contains { !currentIds.contains("schedule_\($0.scheduleSeq)") }
        
        if hasNew {
            storage.saveScheduleInvitations(scheduleInvitations: scheduleInvitations)
            hasUnreadNotifications = true
        }
    }
    
    private func checkNewFriendRequests(friendRequests: [FriendRequest]) {
        let currentIds = storage.savedNotificationIds
        let hasNew = friendRequests.contains { !currentIds.contains("friend_\($0.friendRequestSeq)") }
        
        if hasNew {
            storage.saveFriendRequests(friendRequests: friendRequests)
            hasUnreadNotifications = true
        }
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
