//
//  CheckEmailUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

protocol CheckEmailUseCase {
    func execute(email: String, completion: @escaping (Result<CheckEmailResponse, Error>) -> Void)
}

class CheckEmailUseCaseImpl: CheckEmailUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(email: String, completion: @escaping (Result<CheckEmailResponse, Error>) -> Void) {
        memberRepository.getCheckEmail(email: email) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
