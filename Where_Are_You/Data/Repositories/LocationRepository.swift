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
    private let LocationService: LocationRepositoryProtocol
    
    init(LocationService: LocationRepositoryProtocol) {
        self.LocationService = LocationService
    }
    
    func getLocation(completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, any Error>) -> Void) {
        LocationService.getLocation(completion: completion)
    }
}
