//
//  MemberSnsBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

struct MemberSnsBody: ParameterConvertible {
    var userName: String
    var email: String
    var password: String
    var loginType: String
    var fcmToken: String
}
