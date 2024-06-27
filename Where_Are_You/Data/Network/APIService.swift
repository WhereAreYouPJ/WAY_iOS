//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

protocol APIServiceProtocol {
    func signUp(request: User, completion: @escaping (Result<GenericResponse<SignUp>, Error>) -> Void)
    func checkUserIDAvailability(userID: String, completion: @escaping (Result<GenericResponse<CheckDuplicateUserID>, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<GenericResponse<CheckDuplicateEmail>, Error>) -> Void)
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    func verifyEmailCode(email: String, code: String, completion: @escaping (Result<Void, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://wlrmadjel.com/v1"
    
    func signUp(request: User, completion: @escaping (Result<GenericResponse<SignUp>, any Error>) -> Void) {
        let url = "\(baseURL)/member"
        
        let parameters: [String: Any] = [
            "userName": request.userName,
            "userID": request.userID,
            "password": request.password,
            "email": request.email
        ]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .responseDecodable(of: GenericResponse<SignUp>.self) { response in
                switch response.result {
                case.success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkUserIDAvailability(userID: String, completion: @escaping (Result<GenericResponse<CheckDuplicateUserID>, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkID"
        
        let parameters: [String: Any] = ["userID": userID]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
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
            .responseDecodable(of: GenericResponse<CheckDuplicateEmail>.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
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
            let parameters: [String: Any] = ["email": email, "code": code]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).response { response in
                switch response.result {
                case .success:
                    if response.response?.statusCode == 200 {
                        completion(.success(()))
                    } else {
                        let error = NSError(domain: "", code: response.response?.statusCode ?? -1, userInfo: [NSLocalizedDescriptionKey: "Email verification failed"])
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
}

struct EmptyResponse: Decodable {}
