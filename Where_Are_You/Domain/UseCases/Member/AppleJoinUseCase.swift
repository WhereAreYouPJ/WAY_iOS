//
//  AppleJoinUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/7/2025.
//

import Foundation

protocol AppleJoinUseCase {
    func execute(userName: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AppleJoinUseCaseImpl: AppleJoinUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(userName: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postAppleJoin(userName: userName, code: code, completion: completion)
    }
}
