//
//  UserDefaultManager.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/7/2024.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
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
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    // MARK: - RefreshToken
    
    func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    // MARK: - MemberSeq
    
    func saveMemberSeq(_ seq: Int) {
        UserDefaults.standard.set(seq, forKey: memberSeqKey)
    }
    
    func getMemberSeq() -> Int {
        return UserDefaults.standard.integer(forKey: memberSeqKey)
    }
    
    // MARK: - MemberCode
    
    func saveMemberCode(_ code: String) {
        UserDefaults.standard.set(code, forKey: memberCode)
    }
    
    func getMemberCode() -> String? {
        return UserDefaults.standard.string(forKey: memberCode)
    }
    
    // MARK: - UserName
    
    func saveUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: userName)
    }
    
    func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: userName)
    }
    
    // MARK: - ProfileImage
    
    func saveProfileImage(_ profileImage: String) {
        UserDefaults.standard.set(profileImage, forKey: profileImage)
    }
    
    func getProfileImage() -> String {
        return UserDefaults.standard.string(forKey: profileImage) ?? AppConstants.defaultProfileImageUrl
    }
    
    // MARK: - IsLoggedIn
    
    func saveIsLoggedIn(_ loggedIn: Bool) {
        UserDefaults.standard.set(loggedIn, forKey: isLoggedIn)
    }
    
    func getIsLoggedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: isLoggedIn)
    }
    
    // MARK: - FcmToken
    
    func saveFcmToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: fcmToken)
    }
    
    func getFcmToken() -> String {
        return UserDefaults.standard.string(forKey: fcmToken) ?? ""
    }
    
    // MARK: - ClearData
    func clearData() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: memberSeqKey)
        UserDefaults.standard.removeObject(forKey: memberCode)
        UserDefaults.standard.removeObject(forKey: userName)
        UserDefaults.standard.removeObject(forKey: profileImage)
        UserDefaults.standard.removeObject(forKey: isLoggedIn)
        UserDefaults.standard.removeObject(forKey: fcmToken)
    }
}
