//
//  MemberRepository.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/6/2024.
//

import Alamofire

protocol MemberRepositoryProtocol {
    func putUserName(userName: String, completion: @escaping (Result<Void, Error>) -> Void)
    func putProfileImage(images: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func postSignUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postMemberSns(request: MemberSnsBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postResetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postLogout(completion: @escaping (Result<Void, Error>) -> Void)
    func postLogin(request: LoginBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postMemberLink(request: MemberSnsBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEmailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEmailVerifyPassword(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void)
    func postEmailSend(email: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func getMemberSearch(memberCode: String, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void)
    func getMemberDetails(completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void)
    func getCheckEmail(email: String, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void)
    
    func deleteMember(request: DeleteMemberBody, completion: @escaping (Result<Void, Error>) -> Void)
}

class MemberRepository: MemberRepositoryProtocol {
    private let memberService: MemberServiceProtocol
    
    init(memberService: MemberServiceProtocol) {
        self.memberService = memberService
    }
    
    // MARK: - PUT

    func putUserName(userName: String, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.putUserName(userName: userName, completion: completion)
    }
    
    func putProfileImage(images: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberService.putProfileImage(images: images, completion: completion)
    }
    
    // MARK: - POST
    
    func postSignUp(request: SignUpBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.postSignUp(request: request, completion: completion)
    }
    
    func postMemberSns(request: MemberSnsBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberService.postMemberSns(request: request, completion: completion)
    }
    
    func postResetPassword(request: ResetPasswordBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.postResetPassword(request: request, completion: completion)
    }
    
    func postLogout(completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.postLogout { result in
            switch result {
            case .success:
                UserDefaultsManager.shared.clearData()
                UserDefaultsManager.shared.saveIsLoggedIn(false)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func postLogin(request: LoginBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberService.postLogin(request: request) { result in
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
    
    func postMemberLink(request: MemberSnsBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberService.postMemberLink(request: request, completion: completion)
    }
    
    func postEmailVerify(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.postEmailVerify(request: request, completion: completion)
    }
    
    func postEmailVerifyPassword(request: EmailVerifyBody, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.postEmailVerifyPassword(request: request, completion: completion)
    }
    
    func postEmailSend(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        memberService.postEmailSend(email: email, completion: completion)
    }
    
    // MARK: - GET

    func getMemberSearch(memberCode: String, completion: @escaping (Result<GenericResponse<MemberSearchResponse>, Error>) -> Void) {
        memberService.getMemberSearch(memberCode: memberCode, completion: completion)
    }
    
    func getMemberDetails(completion: @escaping (Result<GenericResponse<MemberDetailsResponse>, Error>) -> Void) {
        memberService.getMemberDetails { result in
            switch result {
            case .success(let response):
                let memberDetailData = response.data
                UserDefaultsManager.shared.saveProfileImageURL(memberDetailData.profileImage)
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getCheckEmail(email: String, completion: @escaping (Result<GenericResponse<CheckEmailResponse>, Error>) -> Void) {
        memberService.getCheckEmail(email: email, completion: completion)
    }
    
    // MARK: - DELETE
    
    func deleteMember(request: DeleteMemberBody, completion: @escaping (Result<Void, any Error>) -> Void) {
        memberService.deleteMember(request: request, completion: completion)
    }
}
