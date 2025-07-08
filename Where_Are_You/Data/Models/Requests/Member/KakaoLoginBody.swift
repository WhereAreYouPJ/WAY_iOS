//
//  KakaoLoginBody.swift
//  Where_Are_You
//
//  Created by juhee on 07.07.25.
//

import Foundation

struct KakaoLoginBody: ParameterConvertible {
    let code: String // 카카오에서 받아온 OAuth인증 토큰
    let fcmToken: String
}
