//
//  CoordinateRepository.swift
//  Where_Are_You
//
//  Created by juhee on 09.12.24.
//

import Foundation

protocol CoordinateRepositoryProtocol {
    func getCoordinate(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetCoordinateResponse>, Error>) -> Void)
    func postCoordinate(request: PostCoordinateBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class CoordinateRepository: CoordinateRepositoryProtocol {
    private let coordinateService: CoordinateServiceProtocol
    
    init(coordinateService: CoordinateServiceProtocol) {
        self.coordinateService = coordinateService
    }
    
    func getCoordinate(scheduleSeq: Int, completion: @escaping (Result<GenericResponse<GetCoordinateResponse>, any Error>) -> Void) {
        coordinateService.getCoordinate(scheduleSeq: scheduleSeq, completion: completion)
    }
    
    func postCoordinate(request: PostCoordinateBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        coordinateService.postCoordinate(request: request, completion: completion)
    }
}
