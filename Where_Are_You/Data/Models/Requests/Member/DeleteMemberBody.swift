//
//  DeleteMemberBody.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

struct DeleteMemberBody: ParameterConvertible {
    let memberSeq: Int
    let password: String
    let comment: String
    let loginType: String
}
