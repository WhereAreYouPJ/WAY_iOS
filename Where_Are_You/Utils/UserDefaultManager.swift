//
//  UserDefaultManager.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/7/2024.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let memberSeqKey = "memberSeq"
    private let memberCode = "memberCode"
    private let userName = "userName"
    private let profileImage = "profileImage"
    private let isLoggedIn = "isLoggedIn"
    private let fcmToken = "fcmToken"
    
    private init() {}
    
    // MARK: - AccessToken
    func saveAccessToken(_ token: String) {
        defaults.set(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return defaults.string(forKey: accessTokenKey)
    }
    
    // MARK: - RefreshToken
    func saveRefreshToken(_ token: String) {
        defaults.set(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return defaults.string(forKey: refreshTokenKey)
    }
    
    // MARK: - MemberSeq
    func saveMemberSeq(_ seq: Int) {
        defaults.set(seq, forKey: memberSeqKey)
    }
    
    func getMemberSeq() -> Int {
        return defaults.integer(forKey: memberSeqKey)
    }
    
    // MARK: - MemberCode
    func saveMemberCode(_ code: String) {
        defaults.set(code, forKey: memberCode)
    }
    
    func getMemberCode() -> String? {
        return defaults.string(forKey: memberCode)
    }
    
    // MARK: - UserName
    func saveUserName(_ name: String) {
        defaults.set(name, forKey: userName)
    }
    
    func getUserName() -> String? {
        return defaults.string(forKey: userName)
    }
    
    // MARK: - ProfileImage
    func saveProfileImage(_ profileImage: String) {
        defaults.set(profileImage, forKey: profileImage)
    }
    
    func getProfileImage() -> String {
        return defaults.string(forKey: profileImage) ?? AppConstants.defaultProfileImageUrl
    }
    
    // MARK: - IsLoggedIn
    func saveIsLoggedIn(_ loggedIn: Bool) {
        defaults.set(loggedIn, forKey: isLoggedIn)
    }
    
    func getIsLoggedIn() -> Bool {
        return defaults.bool(forKey: isLoggedIn)
    }
    
    // MARK: - FcmToken
    func saveFcmToken(_ token: String) {
        defaults.set(token, forKey: fcmToken)
    }
    
    func getFcmToken() -> String {
        return defaults.string(forKey: fcmToken) ?? ""
    }
    
    // MARK: - ClearData
    func clearLoginData() { // 로그아웃
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: refreshTokenKey)
        
        defaults.removeObject(forKey: memberSeqKey)
        defaults.removeObject(forKey: memberCode)
        defaults.removeObject(forKey: userName)
        defaults.removeObject(forKey: profileImage)
        
        defaults.removeObject(forKey: isLoggedIn)
        
        defaults.removeObject(forKey: "hasUnreadNotifications")
        defaults.removeObject(forKey: "notificationIds")
    }
    
    func clearData() { // 탈퇴
        defaults.removeObject(forKey: accessTokenKey)
        defaults.removeObject(forKey: refreshTokenKey)
        
        defaults.removeObject(forKey: memberSeqKey)
        defaults.removeObject(forKey: memberCode)
        defaults.removeObject(forKey: userName)
        defaults.removeObject(forKey: profileImage)
        
        defaults.removeObject(forKey: isLoggedIn)
        
        defaults.removeObject(forKey: fcmToken)
        
        defaults.removeObject(forKey: "hasUnreadNotifications")
        defaults.removeObject(forKey: "notificationIds")
    }
}
