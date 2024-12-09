//
//  GetCoordinateUseCase.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Foundation

protocol GetCoordinateUseCase {
    func execute(memberSeq: Int, scheduleSeq: Int, completion: @escaping (Result<GetCoordinateResponse, Error>) -> Void)
}

class GetCoordinateUseCaseImpl: GetCoordinateUseCase {
    private let coordinateRepository: CoordinateRepositoryProtocol
    
    init(coordinateRepository: CoordinateRepositoryProtocol) {
        self.coordinateRepository = coordinateRepository
    }
    
    func execute(memberSeq: Int, scheduleSeq: Int, completion: @escaping (Result<GetCoordinateResponse, any Error>) -> Void) {
        coordinateRepository.getCoordinate(memberSeq: memberSeq, scheduleSeq: scheduleSeq) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
