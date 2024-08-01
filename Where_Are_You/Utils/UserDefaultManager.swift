//
//  UserDefaultManager.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/7/2024.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init() {}
    
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    private let memberSeqKey = "memberSeq"
    private let memberCode = "memberCode"
    
    func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: accessTokenKey)
    }
    
    func saveRefreshToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: refreshTokenKey)
    }
    
    func saveMemberSeq(_ seq: Int) {
        UserDefaults.standard.set(seq, forKey: memberSeqKey)
    }
    
    func saveMemberCode(_ code: String) {
        UserDefaults.standard.set(code, forKey: memberCode)
    }
    
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }
    
    func getMemberSeq() -> Int? {
        return UserDefaults.standard.integer(forKey: memberSeqKey)
    }
    
    func getMemberCode() -> String? {
        return UserDefaults.standard.string(forKey: memberCode)
    }
    
    func clearData() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
        UserDefaults.standard.removeObject(forKey: memberSeqKey)
    }
}
