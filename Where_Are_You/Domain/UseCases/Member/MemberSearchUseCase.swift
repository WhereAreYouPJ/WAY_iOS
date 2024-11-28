//
//  MemberSearchUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

protocol MemberSearchUseCase {
    func execute(memberCode: String, completion: @escaping (Result<MemberSearchResponse, Error>) -> Void)
}

class MemberSearchUseCaseImpl: MemberSearchUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(memberCode: String, completion: @escaping (Result<MemberSearchResponse, Error>) -> Void) {
        memberRepository.getMemberSearch(memberCode: memberCode) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
