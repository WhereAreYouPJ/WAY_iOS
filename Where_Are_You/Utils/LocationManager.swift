//
//  LocationManager.swift
//  Where_Are_You
//
//  Created by juhee on 20.02.25.
//

import Foundation
import Combine

/// 위치 정보를 앱 전체에서 효율적으로 관리하기 위한 싱글톤 클래스
class LocationManager {
    static let shared = LocationManager()
    
    private init() {
        loadFavoriteLocations()
    }
    
    // 즐겨찾기 위치 목록
    @Published var favoriteLocations: [Location] = []
    private var cancellables = Set<AnyCancellable>()
    
    private let locationRepository = LocationRepository(locationService: LocationService())
    
    /// 즐겨찾기 위치 목록 로드
    func loadFavoriteLocations() {
        let getLocationUseCase = GetLocationUseCaseImpl(locationRepository: locationRepository)
        
        getLocationUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let favLocations):
                    self.favoriteLocations = favLocations.map { favLocation in
                        Location(
                            locationSeq: favLocation.locationSeq,
                            sequence: favLocation.sequence,
                            location: favLocation.location,
                            streetName: favLocation.streetName,
                            x: favLocation.x,
                            y: favLocation.y
                        )
                    }
                    print("LocationManager: \(self.favoriteLocations.count)개의 즐겨찾기 위치 로드됨")
                case .failure(let error):
                    print("LocationManager: 즐겨찾기 로드 실패 - \(error.localizedDescription)")
                }
            }
        }
    }
    
    /// 위치에 즐겨찾기 시퀀스 적용
    func applyFavoriteSequence(to location: Location) -> Location {
        // 즐겨찾기에 있는 위치인지 확인
        if let favoriteLocation = favoriteLocations.first(where: {
            $0.streetName == location.streetName && $0.location == location.location
        }) {
            // 시퀀스와 locationSeq 모두 업데이트
            var updatedLocation = location
            updatedLocation.sequence = favoriteLocation.sequence
            updatedLocation.locationSeq = favoriteLocation.locationSeq
            return updatedLocation
        }
        
        // 즐겨찾기에 없으면 원래 위치 반환
        return location
    }
    
    /// 주소 정보로 즐겨찾기 목록에서 위치 찾기
    func findLocationByAddress(location: String, streetName: String) -> Location? {
        return favoriteLocations.first(where: {
            $0.location == location && $0.streetName == streetName
        })
    }
    
    /// 시퀀스로 즐겨찾기 위치 찾기
    func findLocationBySequence(_ sequence: Int) -> Location? {
        return favoriteLocations.first(where: { $0.sequence == sequence })
    }
    
    /// locationSeq로 즐겨찾기 위치 찾기
    func findLocationByLocationSeq(_ locationSeq: Int) -> Location? {
        return favoriteLocations.first(where: { $0.locationSeq == locationSeq })
    }
    
    /// 위치가 즐겨찾기인지 확인
    func isFavorite(location: Location) -> Bool {
        return favoriteLocations.contains(where: {
            $0.streetName == location.streetName && $0.location == location.location
        })
    }
}
