//
//  SignUpUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol SignUpUseCase {
    func execute(request: SignUpRequestModel, completion: @escaping (Result<SignUpResponseModel, Error>) -> Void)
}
