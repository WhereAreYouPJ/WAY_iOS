//
//  MemberAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Moya

enum MemberAPI {
    case putUserName(memberSeq: Int, userName: String)
    case putProfileImage(memberSeq: Int, images: UIImage)
    
    case postSignUp(request: SignUpBody)
    case postTokenReissue(request: TokenReissueBody)
    case postMemberSns(request: MemberSnsBody)
    case postResetPassword(request: ResetPasswordBody)
    case postLogout(memberSeq: Int)
    case postLogin(request: LoginBody)
    
    case postKakaoJoin(request: KakaoJoinBody)
    case postKakaoLogin(request: KakaoLoginBody)
    
    case postMemberLink(request: MemberSnsBody)
    case postEmailVerify(requst: EmailVerifyBody)
    case postEmailVerifyPassword(request: EmailVerifyBody)
    case postEmailSend(email: String)
    case postEmailSendV2(email: String)
    case postAppleJoin(userName: String, code: String)
    case postAppleLogin(code: String, fcmToken: String)
    
    case getMemberSearch(memberCode: String)
    case getMemberDetails(memberSeq: Int)
    case getCheckEmail(email: String)
    
    case deleteMember(request: DeleteMemberBody)
}

extension MemberAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .putUserName:
            return "/member/user-name"
        case .putProfileImage:
            return "/member/profile-image"
            
        case .postSignUp:
            return "/member"
        case .postTokenReissue:
            return "/member/tokenReissue"
        case .postMemberSns:
            return "/member/sns"
        case .postResetPassword:
            return "/member/resetPassword"
        case .postLogout:
            return "/member/logout"
        case .postLogin:
            return "/member/login"
            
        case .postKakaoJoin:
            return "/member/kakaoJoin"
        case .postKakaoLogin:
            return "/member/kakao/login"
            
        case .postMemberLink:
            return "/member/link"
        case .postEmailVerify:
            return "/member/email/verify"
        case .postEmailVerifyPassword:
            return "/member/email/verifyPassword"
        case .postEmailSend:
            return "/member/email/send"
        case .postEmailSendV2:
            return "/member/email/send/v2"
        case .postAppleJoin:
            return "/member/appleJoin"
        case .postAppleLogin:
            return "/member/apple/login"
            
        case .getMemberSearch:
            return "/member/search"
        case .getMemberDetails:
            return "/member/details"
        case .getCheckEmail:
            return "/member/checkEmail"
            
        case .deleteMember:
            return "/member/member"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .putUserName, .putProfileImage:
            return .put
        case .postSignUp, .postTokenReissue, .postMemberSns, .postResetPassword, .postLogout, .postLogin, .postMemberLink, .postEmailVerify, .postEmailVerifyPassword, .postEmailSend, .postEmailSendV2, .postAppleJoin, .postAppleLogin:
            return .post
        case .getMemberSearch, .getMemberDetails, .getCheckEmail:
            return .get
        case .deleteMember:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .putUserName(let memberSeq, let userName):
            return .requestParameters(parameters: ["memberSeq": memberSeq, "userName": userName], encoding: JSONEncoding.default)
        case .putProfileImage(let memberSeq, let images):
            let multipartData = MultipartFormDataHelper.createMultipartData(from: memberSeq, images: images)
            return .uploadMultipart(multipartData)
            
        case .postSignUp(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postTokenReissue(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postMemberSns(request: let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postResetPassword(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postLogout(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: JSONEncoding.default)
        case .postLogin(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            
        case .postKakaoJoin(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postKakaoLogin(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
            
        case .postMemberLink(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postEmailVerify(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postEmailVerifyPassword(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .postEmailSend(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .postEmailSendV2(let email):
            return .requestParameters(parameters: ["email": email], encoding: JSONEncoding.default)
        case .postAppleJoin(let userName, let code):
            return .requestParameters(parameters: ["userName": userName, "code": code], encoding: JSONEncoding.default)
        case .postAppleLogin(let code, let fcmToken):
            return .requestParameters(parameters: ["code": code, "fcmToken": fcmToken], encoding: JSONEncoding.default)
            
        case .getMemberSearch(let memberCode):
            return .requestParameters(parameters: ["memberCode": memberCode], encoding: URLEncoding.queryString)
        case .getMemberDetails(let memberSeq):
            return .requestParameters(parameters: ["memberSeq": memberSeq], encoding: URLEncoding.queryString)
        case .getCheckEmail(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
            
        case .deleteMember(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .putProfileImage:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}
