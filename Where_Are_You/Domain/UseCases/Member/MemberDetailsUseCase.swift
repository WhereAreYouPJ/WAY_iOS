//
//  MemberDetailsUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Foundation

protocol MemberDetailsUseCase {
    func execute(request: MemberDetailsParameters, completion: @escaping (Result<MemberDetailsResponse, Error>) -> Void)
}

class MemberDetailsUseCaseImpl: MemberDetailsUseCase {
    private let memberRepository: MemberRepositoryProtocol
    
    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }
    
    func execute(request: MemberDetailsParameters, completion: @escaping (Result<MemberDetailsResponse, Error>) -> Void) {
        memberRepository.memberDetails(request: request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
