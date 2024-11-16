//
//  MemberSnsBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

struct MemberSnsBody: ParameterConvertible {
    let userName: String
    let email: String
    let password: String
    let loginType: String
    let fcmToken: String
}
