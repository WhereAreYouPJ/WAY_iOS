//
//  APIService.swift
//  Where_Are_You
//
//  Created by 오정석 on 19/6/2024.
//

import Alamofire
import Moya

// MARK: - MemberServiceProtocol

protocol MemberServiceProtocol {
    func modifyUserName(userName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
    func resetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func logout(completion: @escaping (Result<Void, Error>) -> Void)
    func login(request: LoginBody, completion: @escaping (Result<GenericResponse<LoginResponse>, Error>) -> Void)
    func emailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailVerifyPassword(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailSend(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func memberSearch(request: MemberSearchParameters, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void)
    func memberDetails(completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void)
    func checkEmail(request: CheckEmailParameters, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void)
}

// MARK: - AuthService

class MemberService: MemberServiceProtocol {
    // MARK: - Properties
    private var provider = MoyaProvider<MemberAPI>()
    
    private var memberSeq: Int {
        return UserDefaultsManager.shared.getMemberSeq()
    }
    
    init() {
        let tokenPlugin = AuthTokenPlugin(tokenClosure: {
            return UserDefaultsManager.shared.getAccessToken()
        })
        self.provider = MoyaProvider<MemberAPI>(plugins: [tokenPlugin])
    }
    
    // MARK: - APIService
    func modifyUserName(userName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.modifyUserName(memberSeq: memberSeq, userName: userName)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.signUp(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func resetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.resetPassword(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func logout(completion: @escaping (Result<Void, Error>) -> Void) {
        let request = LogoutBody(memberSeq: memberSeq)
        provider.request(.logout(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func login(request: LoginBody, completion: @escaping (Result<GenericResponse<LoginResponse>, Error>) -> Void) {
        provider.request(.login(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func emailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.emailVerify(requst: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func emailVerifyPassword(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.emailVerifyPassword(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func emailSend(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.emailSend(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func memberSearch(request: MemberSearchParameters, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void) {
        provider.request(.memberSearch(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func memberDetails(completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void) {
        provider.request(.memberDetails(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func checkEmail(request: CheckEmailParameters, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void) {
        provider.request(.checkEmail(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
