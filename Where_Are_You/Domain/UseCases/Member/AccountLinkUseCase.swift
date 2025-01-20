//
//  AccountLinkUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol AccountLinkUseCase {
    func execute(request: MemberSnsBody, completion: @escaping (Result<Void, any Error>) -> Void)
}

class AccountLinkUseCaseImpl: AccountLinkUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: MemberSnsBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberRepository.postMemberLink(request: request, completion: completion)
    }
}
