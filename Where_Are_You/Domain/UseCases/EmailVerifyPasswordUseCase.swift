//
//  EmailVerifyPasswordUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

protocol EmailVerifyPasswordUseCase {
    func execute(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class EmailVerifyPasswordUseCaseImpl: EmailVerifyPasswordUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.emailVerifyPassword(request: request, completion: completion)
    }
}
