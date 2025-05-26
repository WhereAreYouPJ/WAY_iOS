//
//  SplashViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 26/5/2025.
//

import Foundation

class SplashViewModel {
    private let getServerStatusUseCase: GetServerStatusUseCase

    var onServerStatus: ((Bool) -> Void)?
    
    init(getServerStatusUseCase: GetServerStatusUseCase) {
        self.getServerStatusUseCase = getServerStatusUseCase
    }
    
    func checkServerHealth() {
        getServerStatusUseCase.execute { result in
            switch result {
            case .success:
                self.onServerStatus?(true)
            case .failure:
                self.onServerStatus?(false)
            }
        }
    }
}
