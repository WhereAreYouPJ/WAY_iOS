//
//  AuthAPI.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Moya

enum AuthAPI {
    case signUp(request: SignUpBody)
    // 비밀번호 재설정 API
    case resetPassword(request: ResetPasswordBody)
    case logout(request: LogoutBody)
    case login(request: LoginBody)
    // 인증코드 검증 API
    case emailVerify(requst: EmailVerifyBody)
    // 비밀번호 재설정 인증코드 API
    case emailVerifyPassword(request: EmailVerifyPasswordBody)
    // 인증 메일 전송 API
    case emailSend(request: EmailSendBody)
    // 회원 검색 API(by membercode)
    case search(request: SearchParameters)
    // 회원 상세 정보 API(by memberSeq)
    case details(request: DetailsParameters)
    // 이메일 중복 체크 API
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
        case .search:
            return "/member/search"
        case .details:
            return "/member/details"
        case .checkEmail:
            return "/member/checkEmail"
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
        case .search(let request):
            return .requestParameters(parameters: request.toParameters() ?? [:], encoding: JSONEncoding.default)
        case .details(let request):
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
