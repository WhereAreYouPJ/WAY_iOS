//
//  NotificationStorage.swift
//  Where_Are_You
//
//  Created by juhee on 22.02.25.
//

import Foundation

class NotificationStorage {
    private let defaults = UserDefaults.standard
    private let notificationsKey = "notifications"
    
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
    
    // MARK: 알림을 로컬 저장소에 저장
    func saveScheduleInvitations(scheduleInvitations: [Schedule]) {
        var notificationIds = savedNotificationIds
        scheduleInvitations.forEach { notificationIds.insert("schedule_\($0.scheduleSeq)") }
        print("알림 IDs: \(notificationIds)")
        savedNotificationIds = notificationIds
    }
    
    func saveFriendRequests(friendRequests: [FriendRequest]) {
        var notificationIds = savedNotificationIds
        friendRequests.forEach { notificationIds.insert("friend_\($0.friendRequestSeq)") }
        print("알림 IDs: \(notificationIds)")
        savedNotificationIds = notificationIds
    }
    
    // MARK: 알림을 로컬 저장소에서 삭제
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
