//
//  APIResponseHandler.swift
//  Where_Are_You
//
//  Created by 오정석 on 10/9/2024.
//

import Foundation
import Moya

class APIResponseHandler {
    static func handleResponse<T>(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        switch result {
        case .success(let response):
            do {
                // TODO: 앱 개발 완료후 지우기(받는 데이터 정보 확인용)
//                if let json = try? response.mapJSON() {
//                    print("Response JSON: \(json)")
//                }
                
                let data = try response.map(T.self)
                completion(.success(data))
            } catch DecodingError.valueNotFound(let type, let context) {
                print("Value not found for type \(type): \(context.debugDescription)")
                completion(.failure(DecodingError.valueNotFound(type, context)))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    static func handleResponse(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (Result<Void, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                _ = try response.filterSuccessfulStatusCodes()
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
