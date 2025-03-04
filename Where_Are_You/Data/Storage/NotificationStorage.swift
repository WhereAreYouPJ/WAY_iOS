//
//  NotificationStorage.swift
//  Where_Are_You
//
//  Created by juhee on 22.02.25.
//

import Foundation

// MARK: 알림 관련 데이터만 관리하는 클래스
class NotificationStorage {
    static let shared = NotificationStorage() // 싱글턴 패턴
    
    private let defaults = UserDefaults.standard
    private let notificationsKey = "notificationIds"
    
    private init() {} // 기본 생성자를 private으로 변경하여 외부에서 인스턴스 생성 방지
    
    // MARK: 로컬에 저장된 알림 ID 목록
    var savedNotificationIds: Set<String> {  // Int -> String으로 변경
        get {
            let array = defaults.array(forKey: notificationsKey) as? [String] ?? []
            return Set(array)
        }
        set {
            defaults.set(Array(newValue), forKey: notificationsKey)
        }
    }
    
    // MARK: 알림을 로컬 저장소에 저장 - 읽음 처리
    func saveAllNotificationIds(notificationIds: [String]) {
        var ids = savedNotificationIds
        notificationIds.forEach { ids.insert($0) }
        savedNotificationIds = ids
    }
    
    // MARK: 알림을 로컬 저장소에서 삭제 - 수락/거절 완료
    func removeScheduleInvitation(scheduleSeq: Int) {
        var currentIds = savedNotificationIds
        currentIds.remove("schedule_\(scheduleSeq)")
        savedNotificationIds = currentIds
    }
    
    func removeFriendRequest(friendRequestSeq: Int) {
        var currentIds = savedNotificationIds
        currentIds.remove("friend_\(friendRequestSeq)")
        savedNotificationIds = currentIds
    }
    
    // MARK: 새로운 알림이 있는지 확인
    func hasNewNotifications(scheduleInvites: [Schedule], friendRequests: [FriendRequest]) -> Bool {
        let currentIds = savedNotificationIds
        
        return scheduleInvites.contains { !currentIds.contains("schedule_\($0.scheduleSeq)") } ||
        friendRequests.contains { !currentIds.contains("friend_\($0.friendRequestSeq)") }
    }
}
