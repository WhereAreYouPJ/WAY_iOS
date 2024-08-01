//
//  APIResponseModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/6/2024.
//

import Foundation

struct GenericResponse<T: Codable>: Codable {
    let status: Int
    let message: String
    let data: T
}

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let memberSeq: Int
    let memberCode: String
}

struct MemberSearchResponse: Codable {
    let userName: String
    let memberSeq: Int
    let profileImage: String
}

struct MemberDetailsResponse: Codable {
    let userName: String
    let email: String
    let profileImage: String
}

struct CheckEmailResponse: Codable {
    let email: String
}
