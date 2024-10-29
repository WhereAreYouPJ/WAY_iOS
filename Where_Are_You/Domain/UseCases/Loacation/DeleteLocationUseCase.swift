//
//  DeleteLocationUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/10/2024.
//

import Foundation

protocol DeleteLocationUseCase {
    func execute(request: DeleteFavoriteLocationBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class DeleteLocationUseCaseImpl: DeleteLocationUseCase {
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    func execute(request: DeleteFavoriteLocationBody, completion: @escaping (Result<Void, Error>) -> Void) {
        locationRepository.deleteLocation(request: request, completion: completion)
    }
}
