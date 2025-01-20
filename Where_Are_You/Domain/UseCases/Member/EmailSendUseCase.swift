//
//  EmailSendUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol EmailSendUseCase {
    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class EmailSendUseCaseImpl: EmailSendUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postEmailSend(email: email, completion: completion)
    }
}
