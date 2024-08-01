//
//  LoginUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/7/2024.
//

import Foundation

protocol AccountLoginUseCase {
    func execute(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AccountLoginUseCaseImpl: AccountLoginUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let loginBody = LoginBody(email: email, password: password)
        memberRepository.login(request: loginBody, completion: completion)
    }
}

