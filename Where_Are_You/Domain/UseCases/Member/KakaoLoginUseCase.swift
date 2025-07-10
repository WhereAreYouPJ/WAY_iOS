//
//  KakaoLoginUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 07.07.25.
//

import Foundation

protocol KakaoLoginUseCase {
    func execute(request: KakaoLoginBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class KakaoLoginUseCaseImpl: KakaoLoginUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(request: KakaoLoginBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postKakaoLogin(request: request, completion: completion)
    }
}
