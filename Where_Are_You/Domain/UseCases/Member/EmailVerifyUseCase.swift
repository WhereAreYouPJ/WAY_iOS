//
//  EmailVerifyUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 27/6/2024.
//

import Foundation

protocol EmailVerifyUseCase {
    func execute(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class EmailVerifyUseCaseImpl: EmailVerifyUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postEmailVerify(request: request, completion: completion)
    }
}
