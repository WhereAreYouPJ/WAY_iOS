//
//  LocationBookmarkViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import Foundation

class LocationBookmarkViewModel {
    private let getLocationUseCase: GetLocationUseCase
   
    var onGetLocationBookMarkSuccess: ((String) -> Void)?
    var onGetLocationBookMarkFailure: (() -> Void)?
    
    init(getLocationUseCase: GetLocationUseCase) {
        self.getLocationUseCase = getLocationUseCase
    }
    
    func getLocationBookMark() {
        getLocationUseCase.execute { result in
            switch result {
            case .success(let data):
                self.onGetLocationBookMarkSuccess?("data")
            case .failure(let error):
                self.onGetLocationBookMarkFailure?()
            }
        }
    }
}
