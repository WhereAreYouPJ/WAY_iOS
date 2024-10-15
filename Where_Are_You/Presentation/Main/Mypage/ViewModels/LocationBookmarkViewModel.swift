//
//  LocationBookmarkViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import Foundation

class LocationBookmarkViewModel {
    var locations: [FavLocation] = []
    var onGetLocationBookMark: (() -> Void)?
    var onEmptyLocation: (() -> Void)?
    
    private let getLocationUseCase: GetLocationUseCase
    
    init(getLocationUseCase: GetLocationUseCase) {
        self.getLocationUseCase = getLocationUseCase
    }
    
    func getLocationBookMark() {
        getLocationUseCase.execute { result in
            switch result {
            case .success(let data):
                if data.isEmpty {
                    self.onEmptyLocation?()
                } else {
                    self.locations = data
                    self.onGetLocationBookMark?()
                }
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
    
    func moveLocation(from sourceIndex: Int, to destinationIndex: Int) {
        let movedLocation = locations.remove(at: sourceIndex)
        locations.insert(movedLocation, at: destinationIndex)
    }
    
    func deleteLocations(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            locations.remove(at: index)
        }
    }
}
