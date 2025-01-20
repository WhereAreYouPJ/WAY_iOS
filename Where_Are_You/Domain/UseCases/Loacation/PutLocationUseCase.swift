//
//  PutLocationUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/10/2024.
//

import Foundation

protocol PutLocationUseCase {
    func execute(request: PutFavoriteLocationRequest, completion: @escaping (Result<Void, Error>) -> Void)
}

class PutLocationUseCaseImpl: PutLocationUseCase {
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute(request: PutFavoriteLocationRequest, completion: @escaping (Result<Void, Error>) -> Void) {
        locationRepository.putLocation(request: request, completion: completion)
    }
}
