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
                if let json = try? response.mapJSON() {
                    print("Response JSON: \(json)")
                }
                
                let data = try response.map(T.self)
                completion(.success(data))
            } catch DecodingError.valueNotFound(let type, let context) {
                print("Value not found for type \(type): \(context.debugDescription)")
                completion(.failure(DecodingError.valueNotFound(type, context)))
            } catch {
                completion(.failure(error))
            } catch let decodingError as DecodingError {
                // 디코딩 에러 상세 정보 출력
                switch decodingError {
                case .keyNotFound(let key, let context):
                    print("디코딩 실패 - 찾을 수 없는 키: \(key)")
                    print("컨텍스트: \(context.debugDescription)")
                case .typeMismatch(let type, let context):
                    print("디코딩 실패 - 타입 불일치: \(type)")
                    print("컨텍스트: \(context.debugDescription)")
                case .valueNotFound(let type, let context):
                    print("디코딩 실패 - 값 없음: \(type)")
                    print("컨텍스트: \(context.debugDescription)")
                case .dataCorrupted(let context):
                    print("디코딩 실패 - 데이터 손상")
                    print("컨텍스트: \(context.debugDescription)")
                @unknown default:
                    print("디코딩 실패 - 알 수 없는 에러")
                }
                completion(.failure(decodingError))
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
