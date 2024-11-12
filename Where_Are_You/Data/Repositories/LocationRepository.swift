//
//  LocationRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 13/10/2024.
//

import Foundation

protocol LocationRepositoryProtocol {
    func getLocation(memberSeq: Int, completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, Error>) -> Void)
    func putLocation(request: PutFavoriteLocationRequest, completion: @escaping (Result<Void, Error>) -> Void)
    func postLocation(request: PostFavoriteLocationBody, completion: @escaping (Result<Void, Error>) -> Void)
    func deleteLocation(request: DeleteFavoriteLocationBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class LocationRepository: LocationRepositoryProtocol {
    private let locationService: LocationServiceProtocol
    
    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
    }
    
    func getLocation(memberSeq: Int, completion: @escaping (Result<GenericResponse<GetFavLocationResponse>, any Error>) -> Void) {
        locationService.getLocation(memberSeq: memberSeq, completion: completion)
    }
    
    func putLocation(request: PutFavoriteLocationRequest, completion: @escaping (Result<Void, any Error>) -> Void) {
        locationService.putLocation(request: request, completion: completion)
    }
    
    func postLocation(request: PostFavoriteLocationBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        locationService.postLocation(request: request, completion: completion)
    }
    
    func deleteLocation(request: DeleteFavoriteLocationBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        locationService.deleteLocation(request: request, completion: completion)
    }
}
