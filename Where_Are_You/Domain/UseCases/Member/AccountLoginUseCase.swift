//
//  AccountLoginUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/7/2024.
//

import Foundation

protocol AccountLoginUseCase {
    func execute(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class AccountLoginUseCaseImpl: AccountLoginUseCase {
    private let memberRepository: MemberRepositoryProtocol

    init(memberRepository: MemberRepositoryProtocol) {
        self.memberRepository = memberRepository
    }

    func execute(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberRepository.postLogin(request: request) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                if let apiError = error as? APIError {
                    completion(.failure(apiError))
                } else {
                    completion(.failure(APIError.unknownError(message: "알 수 없는 오류가 발생했습니다.")))
                }
            }
        }
    }
}
