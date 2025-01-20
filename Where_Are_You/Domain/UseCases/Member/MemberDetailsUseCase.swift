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
        print("Fetching member details in MemberDetailsUseCase...")

        memberRepository.getMemberDetails { result in
            switch result {
            case .success(let response):
                print("Successfully fetched member details: \(response)")

                completion(.success(response.data))
            case .failure(let error):
                print("Error fetching member details: \(error.localizedDescription)")

                completion(.failure(error))
            }
        }
    }
}
