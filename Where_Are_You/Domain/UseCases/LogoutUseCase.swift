//
//  LogoutUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

protocol LogoutUseCase {
    func execute(request: LogoutBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class LogoutUseCaseImpl: LogoutUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: LogoutBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.logout(request: request, completion: completion)
    }
}
