//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

protocol APIServiceProtocol {
    func signUp(request: User, completion: @escaping (Result<Void, Error>) -> Void)
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<GenericResponse<CheckDuplicateUserID>, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<GenericResponse<CheckDuplicateEmail>, Error>) -> Void)
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://wlrmadjel.com/v1"
    
    func signUp(request: User, completion: @escaping (Result<Void, any Error>) -> Void) {
        let url = "\(baseURL)/member"
        
        AF.request(url, method: .post, parameters: request, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GenericResponse<SignUp>.self) { response in
                switch response.result {
                case.success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<GenericResponse<CheckDuplicateUserID>, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkId"
        
        let parameters: [String: Any] = ["userId": userId]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GenericResponse<CheckDuplicateUserID>.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<GenericResponse<CheckDuplicateEmail>, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkEmail"
        
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: GenericResponse<CheckDuplicateEmail>.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    // 409 에러를 처리하는 로직 추가
                    if let afError = error.asAFError, afError.responseCode == 409 {
                        let errorResponse = GenericResponse<CheckDuplicateEmail>(status: 409, message: "중복된 이메일 입니다.", data: CheckDuplicateEmail(email: email))
                        completion(.success(errorResponse))
                    } else {
                        completion(.failure(error))
                    }                }
            }
    }
    
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/member/email/send"
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: EmptyResponse.self) { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/member/email/verify"
        let parameters: [String: String] = ["email": email, "code": code]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let message = json["message"] as? String {
                        let customError = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: message])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    //    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
    //        let url = "\(baseURL)/member/email/verify"
    //        let parameters: [String: String] = ["email": email, "code": code]
    //
    //        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
    //            .validate(statusCode: 200..<300)
    //            .responseDecodable(of: EmptyResponse.self) { response in
    //            switch response.result {
    //            case .success:
    //                completion(.success(()))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        }
    //    }
}

struct EmptyResponse: Decodable {}
