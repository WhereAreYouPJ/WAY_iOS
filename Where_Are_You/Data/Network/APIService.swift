//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

protocol APIServiceProtocol {
    func signUp(request: User, completion: @escaping (Result<Void, Error>) -> Void)
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://wlrmadjel.com/v1"
    
    // MARK: - signUp
    
    func signUp(request: User, completion: @escaping (Result<Void, any Error>) -> Void) {
        let url = "\(baseURL)/member"
        
        guard let parameters = request.toParameters() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
            return
        }
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // MARK: - checkUserIDAvailability

    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkId"
        
        let parameters: [String: Any] = ["userId": userId]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: EmptyResponse.self) { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    // 409 에러를 처리하는 로직
                    if let afError = error.asAFError, afError.responseCode == 409 {
                        let customError = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "중복된 아이디 입니다."])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    // MARK: - checkEmailAvailability

    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkEmail"
        
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: EmptyResponse.self) { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    // 409 에러를 처리하는 로직
                    if let afError = error.asAFError, afError.responseCode == 409 {
                        let customError = NSError(domain: "", code: 409, userInfo: [NSLocalizedDescriptionKey: "중복된 이메일 입니다."])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
    
    // MARK: - sendEmailVerificationCode

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
    
    // MARK: - verifyEmailCode

    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/member/email/verify"
        let parameters: [String: String] = ["email": email, "code": code]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: EmptyResponse.self) { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    // 400 에러를 처리하는 로직
                    if let afError = error.asAFError, afError.responseCode == 400 {
                        let customError = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "인증코드가 알맞지 않습니다."])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}

struct EmptyResponse: Decodable {}
