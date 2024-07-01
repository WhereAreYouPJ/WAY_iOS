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
    
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func login(userId: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    
    private let baseURL = "https://wlrmadjel.com/v1"
    
    // MARK: - signUp
    
    func signUp(request: User, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let parameters = request.toParameters() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
            return
        }
        requestAPI(endpoint: "/member",
                   method: .post,
                   parameters: parameters,
                   completion: completion)
    }
    
    // MARK: - checkUserIDAvailability
    
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: Any] = ["userId": userId]
        requestAPI(endpoint: "/member/checkId",
                   method: .get,
                   parameters: parameters,
                   expectedErrorCodes: [409: "중복된 아이디 입니다."],
                   completion: completion)
    }
    
    // MARK: - checkEmailAvailability
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: Any] = ["email": email]
        requestAPI(endpoint: "/member/checkEmail",
                   method: .get,
                   parameters: parameters,
                   expectedErrorCodes: [409: "중복된 이메일 입니다."],
                   completion: completion)
    }
    
    // MARK: - sendEmailVerificationCode
    
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = ["email": email]
        requestAPI(endpoint: "/member/email/send",
                   method: .post,
                   parameters: parameters,
                   completion: completion)
    }
    
    // MARK: - verifyEmailCode
    
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: String] = ["email": email, "code": code]
        requestAPI(endpoint: "/member/email/verify",
                   method: .post,
                   parameters: parameters,
                   expectedErrorCodes: [400: "인증코드가 알맞지 않습니다."],
                   completion: completion)
    }
    
    // MARK: - findUserID
    
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
            let url = "\(baseURL)/member/findId"
        let parameters: [String: Any] = ["email": email, "code": code]
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: FindUserIDResponse.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data.userID))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
        }
    
    // MARK: - login
    
    func login(userId: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId, "password": password]
        requestAPI(endpoint: "/member/login",
                   method: .post,
                   parameters: parameters,
                   completion: completion)
    }
    
    // MARK: - Helper
    
    private func requestAPI(endpoint: String, method: HTTPMethod, parameters: Parameters, expectedErrorCodes: [Int: String] = [:], completion: @escaping (Result<Void, Error>) -> Void) {
        let url = baseURL + endpoint
        
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    if let afError = error.asAFError,
                       let customErrorMessage = expectedErrorCodes[afError.responseCode ?? -1] {
                        let customError = NSError(domain: "", code: afError.responseCode ?? -1, userInfo: [NSLocalizedDescriptionKey: customErrorMessage])
                        completion(.failure(customError))
                    } else {
                        completion(.failure(error))
                    }
                }
            }
    }
}

struct EmptyResponse: Decodable {}
struct FindUserIDResponse: Decodable {
    let userID: String
}
