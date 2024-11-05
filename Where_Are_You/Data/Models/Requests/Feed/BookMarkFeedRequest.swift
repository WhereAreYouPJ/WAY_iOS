//
//  BookMarkFeedRequest.swift
//  Where_Are_You
//
//  Created by 오정석 on 31/10/2024.
//

import Foundation

struct BookMarkFeedRequest: ParameterConvertible {
    let feedSeq: Int
    let memberSeq: Int
}
