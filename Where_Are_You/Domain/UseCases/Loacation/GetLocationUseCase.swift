//
//  GetLocationUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/10/2024.
//

import Foundation

protocol GetLocationUseCase {
    func execute(completion: @escaping (Result<GetFavLocationResponse, Error>) -> Void)
}

class GetLocationUseCaseImpl: GetLocationUseCase {
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute(completion: @escaping (Result<GetFavLocationResponse, any Error>) -> Void) {
        locationRepository.getLocation() { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
