//
//  AuthAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Moya

enum AuthAPI {
    case signUp(request: SignUpBody)
    case resetPassword(request: ResetPasswordBody)
    case logout(request: LogoutBody)
    case login(request: LoginBody)
    case emailVerify(requst: EmailVerifyBody)
    case emailVerifyPassword(request: EmailVerifyPasswordBody)
    case emailSend(request: EmailSendBody)
    case memberSearch(request: MemberSearchParameters)
    case memberDetails(request: MemberDetailsParameters)
    case checkEmail(request: CheckEmailParameters)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Config.baseURL)!
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/member"
        case .resetPassword:
            return "/member/resetPassword"
        case .logout:
            return "/member/logout"
        case .login:
            return "/member/login"
        case .emailVerify:
            return "/member/email/verify"
        case .emailVerifyPassword:
            return "/member/email/verifyPassword"
        case .emailSend:
            return "/member/email/send"
        case .memberSearch:
            return "/member/search"
        case .memberDetails:
            return "/member/details"
        case .checkEmail:
            return "/member/checkEmail"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .signUp, .resetPassword, .logout, .login, .emailVerify, .emailVerifyPassword, .emailSend:
            return .post
        case .memberSearch, .memberDetails, .checkEmail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .signUp(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .resetPassword(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .logout(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .login(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .emailVerify(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .emailVerifyPassword(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .emailSend(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .memberSearch(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .memberDetails(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .checkEmail(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
