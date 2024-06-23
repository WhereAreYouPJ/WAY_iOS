//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

protocol APIServiceProtocol {
    func signUp(request: SignUpRequestModel, completion: @escaping (Result<SignUpResponseModel, Error>) -> Void)
    func checkUserIDAvailability(userID: String, completion: @escaping (Result<CheckAvailabilityResponseModel, Error>) -> Void)
    func checkEmailAvailability(email: String, completion: @escaping (Result<CheckAvailabilityResponseModel, Error>) -> Void)
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<EmailVerificationResponseModel, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    private let baseURL = "https://wlrmadjel.com/v1"
    
    func signUp(request: SignUpRequestModel, completion: @escaping (Result<SignUpResponseModel, any Error>) -> Void) {
        let url = "\(baseURL)/member"
        
        let parameters: [String: Any] = [
            "userName": request.userName,
            "userID": request.userID,
            "password": request.password,
            "email": request.email
        ]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default)
            .responseDecodable(of: SignUpResponseModel.self) { response in
                switch response.result {
                case.success(let data):
                    completion(.success(data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkUserIDAvailability(userID: String, completion: @escaping (Result<CheckAvailabilityResponseModel, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkID"
        
        let parameters: [String: Any] = ["userID": userID]
        
        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: CheckAvailabilityResponseModel.self) { response in
                switch response.result {
                case .success(let availabilityResponse):
                    completion(.success(availabilityResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func checkEmailAvailability(email: String, completion: @escaping (Result<CheckAvailabilityResponseModel, any Error>) -> Void) {
        let url = "\(baseURL)/member/checkEmail"
        
        let parameters: [String: Any] = ["eamil": email]
        
        AF.request(url, method: .get, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: CheckAvailabilityResponseModel.self) { response in
                switch response.result {
                case .success(let availabilityResponse):
                    completion(.success(availabilityResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func sendEmailVerificationCode(email: String, completion: @escaping (Result<EmailVerificationResponseModel, any Error>) -> Void) {
        let url = "\(baseURL)/member/email/verify"
        
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseDecodable(of: EmailVerificationResponseModel.self) { response in
                switch response.result {
                case .success(let verificationResponse):
                    completion(.success(verificationResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
}

//    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
//        let url = "\(baseURL)/member/resetPassword"
//        let parameters: [String: Any] = ["email": email]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let json = value as? [String: Any], let success = json["success"] as? Bool {
//                    completion(.success(success))
//                } else {
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
//                }
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }

