//
//  MemberDetailsUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol MemberDetailsUseCase {
    func execute(completion: @escaping (Result<MemberDetailsResponse, Error>) -> Void)
}

class MemberDetailsUseCaseImpl: MemberDetailsUseCase {
    private let memberRepository: MemberRepositoryProtocol
    
    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(completion: @escaping (Result<MemberDetailsResponse, Error>) -> Void) {
        memberRepository.memberDetails { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
