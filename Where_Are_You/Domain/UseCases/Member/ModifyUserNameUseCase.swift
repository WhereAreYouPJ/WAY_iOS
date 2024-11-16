//
//  ModifyUserNameUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 4/9/2024.
//

import Foundation

protocol ModifyUserNameUseCase {
    func execute(userName: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class ModifyUserNameUseCaseImpl: ModifyUserNameUseCase {
    private let memberRepository: MemberRepositoryProtocol
    
    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(userName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberRepository.putUserName(userName: userName, completion: completion)
    }
}
