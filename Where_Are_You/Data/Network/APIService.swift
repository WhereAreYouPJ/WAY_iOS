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
    func sendEmailVerificationCode(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(userId: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void)
    func resetPassword(userId: String, password: String, checkPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func login(userId: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    
    private let baseURL = "https://wlrmadjel.com/v1"
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    // MARK: - Helper
    
    private func requestAPI<T: Decodable>(endpoint: String, method: HTTPMethod, parameters: Parameters?, responseType: T.Type, expectedErrorCodes: [Int: String] = [:], completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL + endpoint
        
        var encoding: ParameterEncoding = JSONEncoding.default
        if method == .get {
            encoding = URLEncoding.default
        }
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
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
    
    // MARK: - signUp
    
    func signUp(request: User, completion: @escaping (Result<Void, any Error>) -> Void) {
        guard let parameters = request.toParameters() else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid parameters"])))
            return
        }
        requestAPI(endpoint: "/member",
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - checkUserIDAvailability
    
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = ["userId": userId]
        requestAPI(endpoint: "/member/checkId",
                   method: .get,
                   parameters: parameters,
                   responseType: EmptyResponse.self,
                   expectedErrorCodes: [409: "중복된 아이디 입니다."]) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - checkEmailAvailability
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: Any] = ["email": email]
        requestAPI(endpoint: "/member/checkEmail",
                   method: .get,
                   parameters: parameters,
                   responseType: EmptyResponse.self,
                   expectedErrorCodes: [409: "중복된 이메일 입니다."]) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - sendEmailVerificationCode
    
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = ["email": email]
        requestAPI(endpoint: "/member/email/send",
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self) { result in
            completion(result.map { _ in () })
        }
    }
    
    func sendEmailVerificationCode(userId: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId]
        requestAPI(endpoint: "/member/email/sendUserId",
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self) { result in
                    completion(result.map { _ in () })
                }
    }
    
    // MARK: - verifyEmailCode
    
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: String] = ["email": email, "code": code]
        requestAPI(endpoint: "/member/email/verify",
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self,
                   expectedErrorCodes: [400: "인증코드가 알맞지 않습니다."]) { result in
            completion(result.map { _ in () })
        }
    }
    
    func verifyEmailCode(userId: String, code: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId, "code": code]
        requestAPI(endpoint: "/member/email/verifyPassword",
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self,
                   expectedErrorCodes: [400: "인증코드가 알맞지 않습니다."]) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - findUserID
    
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void) {
        let parameters: [String: Any] = ["email": email, "code": code]
        requestAPI(endpoint: "/member/findId", method: .post, parameters: parameters, responseType: GenericResponse<FindIDResponse>.self) { result in
            completion(result.map { $0.data.userId })
        }
    }
    
    // MARK: - resetPassword
    
    func resetPassword(userId: String, password: String, checkPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId, "password": password, "checkPassword": checkPassword]
        requestAPI(endpoint: "/member/resetPassword", method: .post, parameters: parameters, responseType: EmptyResponse.self) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - login
    
    func login(userId: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId, "password": password]
        requestAPI(endpoint: "/member/login", method: .post, parameters: parameters, responseType: EmptyResponse.self) { result in
            completion(result.map { _ in () })
        }
    }
}

struct EmptyResponse: Decodable, Encodable {}
