//
//  AccountSignUpUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol AccountSignUpUseCase {
    func execute(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class AccountSignUpUseCaseImpl: AccountSignUpUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postSignUp(request: request, completion: completion)
    }
}
