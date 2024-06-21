//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

protocol APIServiceProtocol {
    func checkDuplicateID(userID: String, completion: @escaping (Result<Bool, Error>) -> Void)
    func login(userID: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    
    private let baseURL = "https://wlrmadjel.com/v1"
    
    func checkDuplicateID(userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(baseURL)/member/checkId"
        let parameters: [String: Any] = ["userID": userID]
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let isDuplicate = json["isDuplicate"] as? Bool {
                    completion(.success(isDuplicate))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func login(userID: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(baseURL)/member/login"
        let parameters: [String: Any] = ["userID": userID, "password": password]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let user = User(json: json) {
                    completion(.success(user))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func resetPassword(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "\(baseURL)/member/resetPassword"
        let parameters: [String: Any] = ["email": email]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            switch response.result {
            case .success(let value):
                if let json = value as? [String: Any], let success = json["success"] as? Bool {
                    completion(.success(success))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
