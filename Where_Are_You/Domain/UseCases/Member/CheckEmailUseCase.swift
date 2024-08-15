//
//  CheckEmailUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Foundation

protocol CheckEmailUseCase {
    func execute(request: CheckEmailParameters, completion: @escaping (Result<CheckEmailResponse, Error>) -> Void)
}

class CheckEmailUseCaseImpl: CheckEmailUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: CheckEmailParameters, completion: @escaping (Result<CheckEmailResponse, Error>) -> Void) {
//        guard ValidationHelper.isValidEmail(request.email) else {
//            completion(.failure())
//        }
        memberRepository.checkEmail(request: request) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
