//
//  EmailSendV2UseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 9/7/2025.
//

import Foundation

protocol EmailSendV2UseCase {
    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class EmailSendV2UseCaseImpl: EmailSendV2UseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postEmailSendV2(email: email, completion: completion)
    }
}
