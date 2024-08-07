//
//  EmailVerifyBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

struct EmailVerifyBody: ParameterConvertible {
    let email: String
    let code: String
}
