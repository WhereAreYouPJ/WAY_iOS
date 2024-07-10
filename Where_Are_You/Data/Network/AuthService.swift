//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

// MARK: - AuthCredentials

struct AuthCredentials: Codable {
    var userName: String?
    var userId: String?
    var password: String?
    var email: String?
    
    func toParameters() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            return nil
        }
        return json
    }
}

// MARK: - APIServiceProtocol

protocol AuthServiceProtocol {
    func signUp(request: AuthCredentials, completion: @escaping (Result<Void, Error>) -> Void)
    func checkUserIDAvailability(userId: String, completion: @escaping (Result<Void, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func sendVerificationCode(identifier: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(identifier: String, code: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void)
    func findUserID(email: String, code: String, completion: @escaping (Result<String, Error>) -> Void)
    func resetPassword(userId: String, password: String, checkPassword: String, completion: @escaping (Result<Void, Error>) -> Void)
    func login(userId: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

enum VerificationType {
    case userId
    case email
    
    var endpoint: String {
        switch self {
        case .email:
            return "/member/email/send"
        case .userId:
            return "/member/email/senduserId"
        }
    }
    
    var verifyEndpoint: String {
        switch self {
        case .email:
            return "/member/email/verify"
        case .userId:
            return "/member/email/verifyPassword"
        }
        
    }
}

// MARK: - APIService

class AuthService: AuthServiceProtocol {
    
    private let baseURL = Config.baseURL
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    // MARK: - Helper
    
    private func requestAPI<T: Decodable>(endpoint: String,
                                          method: HTTPMethod,
                                          parameters: Parameters?,
                                          responseType: T.Type,
                                          expectedErrorCodes: [Int: String] = [:],
                                          completion: @escaping (Result<T, Error>) -> Void) {
        let url = baseURL + endpoint
        
        var encoding: ParameterEncoding = JSONEncoding.default
        if method == .get {
            encoding = URLEncoding.default
        }
        
        AF.request(url,
                   method: method,
                   parameters: parameters,
                   encoding: encoding)
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
    
    func signUp(request: AuthCredentials, completion: @escaping (Result<Void, any Error>) -> Void) {
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
    
    func sendVerificationCode(identifier: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: Any] = [type == .email ? "email" : "userId": identifier]
        requestAPI(endpoint: type.endpoint,
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - verifyEmailCode
    
    func verifyEmailCode(identifier: String, code: String, type: VerificationType, completion: @escaping (Result<Void, Error>) -> Void) {
        let parameters: [String: String] = [type == .email ? "email" : "userId": identifier, "code": code]
        requestAPI(endpoint: "/member/email/verify",
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
        requestAPI(endpoint: "/member/findId",
                   method: .post,
                   parameters: parameters,
                   responseType: GenericResponse<FindIDResponse>.self) { result in
            completion(result.map { $0.data.userId })
        }
    }
    
    // MARK: - resetPassword
    
    func resetPassword(userId: String, password: String, checkPassword: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId, "password": password, "checkPassword": checkPassword]
        requestAPI(endpoint: "/member/resetPassword",
                   method: .post,
                   parameters: parameters,
                   responseType: EmptyResponse.self) { result in
            completion(result.map { _ in () })
        }
    }
    
    // MARK: - login
    
    func login(userId: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        let parameters: [String: String] = ["userId": userId, "password": password]
        requestAPI(endpoint: "/member/login",
                   method: .post,
                   parameters: parameters,
                   responseType: GenericResponse<LoginResponse>.self) { result in
            switch result {
            case .success(let response):
                // 로그인 성공 시 UserDefaults에 데이터 저장 (임시로 추후에 Keychain, oAuth로 바꿀 것)
                UserDefaultsManager.shared.saveAccessToken(response.data.accessToken)
                UserDefaultsManager.shared.saveRefreshToken(response.data.refreshToken)
                UserDefaultsManager.shared.saveMemberSeq(response.data.memberSeq)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
