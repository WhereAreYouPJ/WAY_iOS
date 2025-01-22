//
//  TokenReissueUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/1/2025.
//

import Foundation

protocol TokenReissueUseCase {
    func execute(request: TokenReissueBody, completion: @escaping (Result<TokenReissueResponse, Error>) -> Void)
}

class TokenReissueUseCaseImpl: TokenReissueUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(request: TokenReissueBody, completion: @escaping (Result<TokenReissueResponse, any Error>) -> Void) {
        memberRepository.postTokenReissue(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
