//
//  SnsSignUpUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol SnsSignUpUseCase {
    func execute(request: MemberSnsBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class SnsSignUpUseCaseImpl: SnsSignUpUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: MemberSnsBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postMemberSns(request: request, completion: completion)
    }
}
