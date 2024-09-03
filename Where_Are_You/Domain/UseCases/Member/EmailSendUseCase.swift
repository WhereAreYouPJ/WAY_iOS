//
//  EmailSendUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol EmailSendUseCase {
    func execute(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class EmailSendUseCaseImpl: EmailSendUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.emailSend(request: request, completion: completion)
    }
}
