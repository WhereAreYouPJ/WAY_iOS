//
//  PostCoordinateUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Foundation

protocol PostCoordinateUseCase {
    func execute(request: PostCoordinateBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class PostCoordinateUseCaseImpl: PostCoordinateUseCase {
    private let coordinateRepository: CoordinateRepositoryProtocol
    
    init(coordinateRepository: CoordinateRepositoryProtocol) {
        self.coordinateRepository = coordinateRepository
    }
    
    func execute(request: PostCoordinateBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        coordinateRepository.postCoordinate(request: request, completion: completion)
    }
}
