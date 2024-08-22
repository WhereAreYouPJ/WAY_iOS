//
//  PhotoAuthService.swift
//  Where_Are_You
//
//  Created by 오정석 on 21/8/2024.
//

import Photos

protocol PhotoAuthService {
    var authorizationStatus: PHAuthorizationStatus { get }
    var isAuthorizationLimited: Bool { get }
    
    func requestAuthorization(completion: @escaping (Result<Void, NSError>) -> Void)
}
