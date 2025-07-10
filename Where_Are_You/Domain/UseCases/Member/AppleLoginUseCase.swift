//
//  AppleLoginUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/7/2025.
//

import Foundation

protocol AppleLoginUseCase {
    func execute(code: String, fcmToken: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class AppleLoginUseCaseImpl: AppleLoginUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(code: String, fcmToken: String, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postAppleLogin(code: code, fcmToken: fcmToken, completion: completion)
    }
}
