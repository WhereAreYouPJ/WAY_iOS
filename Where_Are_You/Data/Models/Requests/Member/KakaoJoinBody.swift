//
//  KakaoJoinBody.swift
//  Where_Are_You
//
//  Created by juhee on 07.07.25.
//

import Foundation

struct KakaoJoinBody: ParameterConvertible {
    let userName: String
    let code: String // 카카오에서 받아온 OAuth인증 토큰
}
