//
//  ResetPasswordUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 2/7/2024.
//

import Foundation

protocol ResetPasswordUseCase {
    func execute(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class ResetPasswordUseCaseImpl: ResetPasswordUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.resetPassword(request: request, completion: completion)
    }
}
