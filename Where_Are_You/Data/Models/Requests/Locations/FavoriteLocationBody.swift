//
//  FavoriteLocationBody.swift
//  Where_Are_You
//
//  Created by juhee on 09.09.24.
//

import Foundation

struct PostFavoriteLocationBody: ParameterConvertible {
    let memberSeq: Int
    let location: String
    let streetName: String
}

struct DeleteFavoriteLocationBody: ParameterConvertible {
    let memberSeq: Int
    let locationSeqs: [Int]
}

struct PutFavoriteLocationBody: ParameterConvertible {
    let locationSeq: Int
    let sequence: Int
}

typealias PutFavoriteLocationRequest = [PutFavoriteLocationBody]
