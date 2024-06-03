//
//  UserUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

protocol UserUseCase {
    func login(email: String, password: String, comlpetion: @escaping(Result<User, Error>) -> Void)
    func register(user: User, completion: @escaping (Result<User, Error>) -> Void)
    func findAccount(email: String, completion: @escaping (Result<String, Error>) -> Void)
    func resetPassword(id: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
}
