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
//        getLocationUseCase.execute { result in
//            switch result {
//            case .success(let data):
//                if data.isEmpty {
//                    self.onEmptyLocation?()
//                } else {
//                    self.locations = data
//                    self.onGetLocationBookMark?()
//                }
//            case .failure(let error):
//                print("\(error.localizedDescription)")
//            }
//        }
        let response: GetFavLocationResponse = getLocationFromServer()
        
        if response.isEmpty {
            self.onEmptyLocation?()
        } else {
            self.locations = response
            self.onGetLocationBookMark?()
        }
    }
    
    // 서버에서 받은 데이터를 대신하는 예시 함수 (서버 호출 대체)
    private func getLocationFromServer() -> GetFavLocationResponse {
        // 서버에서 데이터를 받아오는 함수 대신 예시 데이터를 반환
        return [ // 예시 데이터
            FavLocation(locationSeq: 1, location: "서울대학교", streetName: "관악로"),
            FavLocation(locationSeq: 2, location: "여의도한강공원", streetName: "여의대로"),
            FavLocation(locationSeq: 3, location: "올림픽체조경기장", streetName: "올림픽로")
        ]
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
