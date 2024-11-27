//
//  GetListForSenderUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 27.11.24.
//

import Foundation

protocol GetListForSenderUseCase {
    func execute(completion: @escaping (Result< [GetListForSenderResponse], Error>) -> Void)
}

class GetListForSenderUseCaseImpl: GetListForSenderUseCase {
    private let repository: FriendRequestRepositoryProtocol
    
    init(repository: FriendRequestRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result< [GetListForSenderResponse], Error>) -> Void) {
        repository.getListForSender { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
