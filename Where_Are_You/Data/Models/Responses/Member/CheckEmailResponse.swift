//
//  CheckEmailResponse.swift
//  Where_Are_You
//
//  Created by 오정석 on 5/8/2024.
//

import Foundation

struct CheckEmailResponse: Codable {
    let email: String
    let type: [String]
}
