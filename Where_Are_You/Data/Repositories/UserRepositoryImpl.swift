//
//  UserRepositoryImpl.swift
//  Where_Are_You
//
//  Created by 오정석 on 3/6/2024.
//

import Foundation

class UserRepositoryImpl: UserRepository {
    private let baseURL = "https://wlrmadjel.com/v1"
    
    // MARK: - login
    func login(userID: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/member/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let loginData = ["userID": userID, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: loginData, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - register
    func register(user: User, completion: @escaping (Result<User, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/member")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONEncoder().encode(user)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            do {
                let newUser = try JSONDecoder().decode(User.self, from: data)
                completion(.success(newUser))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - findAccount

    func findAccount(email: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/findID")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }
            
            if let accountID = String(data: data, encoding: .utf8) {
                completion(.success(accountID))
            } else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode account ID"])))
            }
        }.resume()
    }
    
    // MARK: - resetPassword
    func resetPassword(email: String, newPassword: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/resetPassword")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let resetData = ["email": email, "newPassword": newPassword]
        request.httpBody = try? JSONSerialization.data(withJSONObject: resetData, options: [])
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            completion(.success(()))
        }.resume()
    }
    
    // MARK: - checkDuplicateID
    
    func checkDuplicateID(id: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
    }
}
