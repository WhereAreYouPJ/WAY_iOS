//
//  AutoTokenPlugin.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/8/2024.
//

import Moya

class AuthTokenPlugin: PluginType {
    private let tokenClosure: () -> String?
    
    init(tokenClosure: @escaping () -> String?) {
        self.tokenClosure = tokenClosure
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        var request = request
        if let token = tokenClosure() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }
}
