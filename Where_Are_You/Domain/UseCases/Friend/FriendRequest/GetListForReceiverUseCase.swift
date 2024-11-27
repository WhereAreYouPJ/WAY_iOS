//
//  GetListForReceiver.swift
//  Where_Are_You
//
//  Created by juhee on 27.11.24.
//

import Foundation

protocol GetListForReceiverUseCase {
    func execute(completion: @escaping (Result< [GetListForReceiverResponse], Error>) -> Void)
}

class GetListForReceiverUseCaseImpl: GetListForReceiverUseCase {
    private let repository: FriendRequestRepositoryProtocol
    
    init(repository: FriendRequestRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result< [GetListForReceiverResponse], Error>) -> Void) {
        repository.getListForReceiver { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
