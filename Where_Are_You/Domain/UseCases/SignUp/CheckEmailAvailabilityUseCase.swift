//
//  CheckEmailAvailabilityUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol CheckEmailAvailabilityUseCase {
    func execute(email: String, completion: @escaping ( Result<Bool, Error>) -> Void)
}
