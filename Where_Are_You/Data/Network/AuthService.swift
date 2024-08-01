//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire
import Moya

// MARK: - AuthServiceProtocol

protocol MemberServiceProtocol {
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
    func resetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    
    func logout(request: LogoutBody, completion: @escaping (Result<Void, Error>) -> Void)
    func login(request: LoginBody, completion: @escaping (Result<GenericResponse<LoginResponse>, Error>) -> Void)
    func emailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailVerifyPassword(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailSend(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func memberSearch(request: MemberSearchParameters, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void)
    func memberDetails(request: MemberDetailsParameters, completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void)
    func checkEmail(request: CheckEmailParameters, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void)
}

// MARK: - AuthService

class MemberService: MemberServiceProtocol {
    
    private let provider = MoyaProvider<AuthAPI>()
    
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.signUp(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func resetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.resetPassword(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func logout(request: LogoutBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.logout(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func login(request: LoginBody, completion: @escaping (Result<GenericResponse<LoginResponse>, Error>) -> Void) {
        provider.request(.login(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func emailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.emailVerify(requst: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func emailVerifyPassword(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.emailVerifyPassword(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func emailSend(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.emailSend(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func memberSearch(request: MemberSearchParameters, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void) {
        provider.request(.memberSearch(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func memberDetails(request: MemberDetailsParameters, completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void) {
        provider.request(.memberDetails(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    func checkEmail(request: CheckEmailParameters, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void) {
        provider.request(.checkEmail(request: request)) { result in
            self.handleResponse(result, completion: completion)
        }
    }
    
    private func handleResponse<T>(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        switch result {
        case .success(let response):
            do {
                let data = try response.map(T.self)
                completion(.success(data))
            } catch let error {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
    
    private func handleResponse(_ result: Result<Moya.Response, MoyaError>, completion: @escaping (Result<Void, Error>) -> Void) {
        switch result {
        case .success(let response):
            do {
                let _ = try response.filterSuccessfulStatusCodes()
                completion(.success(()))
            } catch let error {
                completion(.failure(error))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}
