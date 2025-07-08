//
//  KakaoJoinUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 07.07.25.
//

import Foundation

protocol KakaoJoinUseCase {
    func execute(request: KakaoJoinBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class KakaoJoinUseCaseImpl: KakaoJoinUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(request: KakaoJoinBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postKakaoJoin(request: request, completion: completion)
    }
}
