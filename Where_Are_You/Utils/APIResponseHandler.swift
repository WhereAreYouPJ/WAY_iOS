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
                let statusCode = response.response?.statusCode ?? 0
                print("Response Status Code: \(statusCode)")
                
                // 성공 상태 코드 처리
                if (200...299).contains(statusCode) {
                    let data = try response.map(T.self)
                    completion(.success(data))
                } else {
                    print("Failed Status Code: \(statusCode)")
                    completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with status code \(statusCode)"])))
                }
            } catch DecodingError.valueNotFound(let type, let context) {
                print("Value not found for type \(type): \(context.debugDescription)")
                completion(.failure(DecodingError.valueNotFound(type, context)))
            } catch {
                completion(.failure(error))
            }
        case .failure(let error):
            // MoyaError와 관련된 추가 정보를 출력
            if let response = error.response {
                print("MoyaError - Status Code: \(response.statusCode)")
                print("MoyaError - Response: \(String(data: response.data, encoding: .utf8) ?? "No Response Data")")
            }
            print("MoyaError: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
    
    static func handleResponse(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (Result<Void, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                // Response Status Code 출력
                let statusCode = response.statusCode
                print("Response Status Code: \(statusCode)")
                
                if (200...299).contains(statusCode) {
                    completion(.success(()))
                } else {
                    // 에러 응답을 ErrorResponse로 디코딩
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: response.data)
                    print("Error Response: \(errorResponse)")
                    completion(.failure(NSError(domain: "",
                                                code: statusCode,
                                                userInfo: ["errorResponse": errorResponse])))
                }
            } catch {
                // 실패한 상태 코드에 대해 상세 정보 출력
                if let moyaError = error as? MoyaError, let response = moyaError.response {
                    let statusCode = response.statusCode
                    let responseBody = String(data: response.data, encoding: .utf8) ?? "No Response Body"
                    print("Failed Status Code: \(statusCode)")
                    print("Response Body: \(responseBody)")
                    
                    // JSON 디코딩 실패 시 기본 에러 처리
                    completion(.failure(NSError(domain: "",
                                                code: statusCode,
                                                userInfo: [NSLocalizedDescriptionKey: "Failed with status code \(statusCode): \(responseBody)"])))
                } else {
                    completion(.failure(error))
                }
            }
        case .failure(let error):
            if let response = error.response {
                print("MoyaError - Status Code: \(response.statusCode)")
                print("MoyaError - Response: \(String(data: response.data, encoding: .utf8) ?? "No Response Data")")
            }
            print("MoyaError: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }
}
