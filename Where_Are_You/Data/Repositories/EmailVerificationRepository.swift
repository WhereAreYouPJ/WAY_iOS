//
//  EmailVerificationRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

protocol EmailVerificationRepository {
    func sendVerificationCode(to email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyCode(for email: String, code: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func findAccount(by email: String, completion: @escaping (Result<String, Error>) -> Void)
}
