//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire

protocol APIServiceProtocol {
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, Error>) -> Void)
}

class APIService: APIServiceProtocol {
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let url = "https://wlrmadjel.com/v1/member/checkId"
        let parameters: [String: Any] = ["id": id]
        
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
}
