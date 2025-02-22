//
//  DeleteMemberUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 16/11/2024.
//

import Foundation

protocol DeleteMemberUseCase {
    func execute(request: DeleteMemberBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteMemberUseCaseImpl: DeleteMemberUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(request: DeleteMemberBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.deleteMember(request: request, completion: completion)
    }
}
