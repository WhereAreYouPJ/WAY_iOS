//
//  UserRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Alamofire

protocol MemberRepositoryProtocol {
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
    func resetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func logout(request: LogoutBody, completion: @escaping (Result<Void, Error>) -> Void)
    func login(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailVerifyPassword(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func emailSend(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void)
    func memberSearch(request: MemberSearchParameters, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void)
    func memberDetails(request: MemberDetailsParameters, completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void)
    func checkEmail(request: CheckEmailParameters, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void)
}

class MemberRepository: MemberRepositoryProtocol {
    
    private let memberService: MemberServiceProtocol
    
    init(memberService: MemberServiceProtocol) {
        self.memberService = memberService
    }
    
    func signUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.signUp(request: request, completion: completion)
    }
    
    func resetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.resetPassword(request: request, completion: completion)
    }
    
    func logout(request: LogoutBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.logout(request: request, completion: completion)
    }
    
    func login(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.login(request: request) { result in
            switch result {
            case .success(let response):
                let loginData = response.data
                UserDefaultsManager.shared.saveAccessToken(loginData.accessToken)
                UserDefaultsManager.shared.saveRefreshToken(loginData.refreshToken)
                UserDefaultsManager.shared.saveMemberSeq(loginData.memberSeq)
                UserDefaultsManager.shared.saveMemberCode(loginData.memberCode)
                UserDefaultsManager.shared.saveIsLoggedIn(true)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func emailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.emailVerify(request: request, completion: completion)
    }
    
    func emailVerifyPassword(request: EmailVerifyPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.emailVerifyPassword(request: request, completion: completion)
    }
    
    func emailSend(request: EmailSendBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.emailSend(request: request, completion: completion)
    }
    
    func memberSearch(request: MemberSearchParameters, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void) {
        memberService.memberSearch(request: request, completion: completion)
    }
    
    func memberDetails(request: MemberDetailsParameters, completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void) {
        memberService.memberDetails(request: request, completion: completion)
    }
    
    func checkEmail(request: CheckEmailParameters, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void) {
        memberService.checkEmail(request: request, completion: completion)
    }
}
