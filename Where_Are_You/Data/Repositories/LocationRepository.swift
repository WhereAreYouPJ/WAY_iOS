//
//  LocationRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/10/2024.
//

import Foundation

protocol LocationRepositoryProtocol {
    func getLocation(completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, Error>) -> Void)
}

class LocationRepository: LocationRepositoryProtocol {
    private let locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
    
    func getLocation(completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, any Error>) -> Void) {
        locationService.getLocation(completion: completion)
    }
}
