//
//  LoginUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/7/2024.
//

import Foundation

protocol AccountLoginUseCase {
    func execute(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class AccountLoginUseCaseImpl: AccountLoginUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.login(request: request, completion: completion)
    }
}

