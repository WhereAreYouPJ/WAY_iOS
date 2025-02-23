//
//  PostLocationUseCase.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/10/2024.
//

import Foundation

protocol PostLocationUseCase {
    func execute(request: PostFavoriteLocationBody, completion: @escaping (Result<GenericResponse<PostFavLocationResponse>, Error>) -> Void)
}

class PostLocationUseCaseImpl: PostLocationUseCase {
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func execute(request: PostFavoriteLocationBody, completion: @escaping (Result<GenericResponse<PostFavLocationResponse>, Error>) -> Void) {
        locationRepository.postLocation(request: request, completion: completion)
    }
}
