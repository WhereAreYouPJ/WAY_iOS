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
