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
    func putUserName(userName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func putProfileImage(images: UIImage, completion: @escaping (Result<Void, Error>) -> Void)
    
    func postSignUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postTokenReissue(request: TokenReissueBody, completion: @escaping (Result<GenericResponse<TokenReissueResponse>, Error>) -> Void)
    func postMemberSns(request: MemberSnsBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postResetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postLogout(completion: @escaping (Result<Void, Error>) -> Void)
    func postLogin(request: LoginBody, completion: @escaping (Result<GenericResponse<LoginResponse>, Error>) -> Void)
    func postMemberLink(request: MemberSnsBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEmailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEmailVerifyPassword(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEmailSend(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getMemberSearch(memberCode: String, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void)
    func getMemberDetails(completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void)
    func getCheckEmail(email: String, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void)
    
    func deleteMember(request: DeleteMemberBody, completion: @escaping (Result<Void, Error>) -> Void)
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
    func putUserName(userName: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.putUserName(memberSeq: memberSeq, userName: userName)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func putProfileImage(images: UIImage, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.putProfileImage(memberSeq: memberSeq, images: images)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postSignUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postSignUp(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postTokenReissue(request: TokenReissueBody, completion: @escaping (Result<GenericResponse<TokenReissueResponse>, any Error>) -> Void) {
        provider.request(.postTokenReissue(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postMemberSns(request: MemberSnsBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postMemberSns(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postResetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postResetPassword(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postLogout(completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postLogout(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postLogin(request: LoginBody, completion: @escaping (Result<GenericResponse<LoginResponse>, Error>) -> Void) {
        provider.request(.postLogin(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postMemberLink(request: MemberSnsBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.postMemberLink(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postEmailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postEmailVerify(requst: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postEmailVerifyPassword(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postEmailVerifyPassword(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func postEmailSend(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        provider.request(.postEmailSend(email: email)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getMemberSearch(memberCode: String, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void) {
        provider.request(.getMemberSearch(memberCode: memberCode)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getMemberDetails(completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void) {
        provider.request(.getMemberDetails(memberSeq: memberSeq)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func getCheckEmail(email: String, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void) {
        provider.request(.getCheckEmail(email: email)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
    
    func deleteMember(request: DeleteMemberBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        provider.request(.deleteMember(request: request)) { result in
            APIResponseHandler.handleResponse(result, completion: completion)
        }
    }
}
