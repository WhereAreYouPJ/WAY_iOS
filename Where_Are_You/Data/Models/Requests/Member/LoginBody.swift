//
//  LoginBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

struct LoginBody: ParameterConvertible {
    let email: String
    let password: String
    let fcmToken: String
    let loginType: String
}
