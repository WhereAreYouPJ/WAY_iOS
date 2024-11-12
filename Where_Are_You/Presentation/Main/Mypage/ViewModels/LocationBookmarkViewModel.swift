//
//  LocationBookmarkViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/8/2024.
//

import Foundation

class LocationBookmarkViewModel {
    // MARK: - Properties
    let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    var locations: [GetFavLocation] = []
    var onGetLocationBookMark: (() -> Void)?
    var onEmptyLocation: (() -> Void)?
    var onDeleteLocationSuccess: (() -> Void)?
    var onDeleteLocationFailure: ((Error) -> Void)?
    var onSelectionChanged: ((Bool) -> Void)?
    var onUpdateLocationSuccess: (() -> Void)?
    var onUpdateLocationFailure: ((String) -> Void)?
    
    var hasSelectedLocations: Bool {
        return !checkedLocations.isEmpty
    }
    
    var checkedLocations = Set<Int>() // 선택된 위치를 저장
    
    private let getLocationUseCase: GetLocationUseCase
    private let putLocationUseCase: PutLocationUseCase
    private let deleteLocationUseCase: DeleteLocationUseCase
    
    // MARK: - Lifecycle
    
    init(getLocationUseCase: GetLocationUseCase, putLocationUseCase: PutLocationUseCase, deleteLocationUseCase: DeleteLocationUseCase) {
        self.getLocationUseCase = getLocationUseCase
        self.putLocationUseCase = putLocationUseCase
        self.deleteLocationUseCase = deleteLocationUseCase
    }
    
    // MARK: - GET
    
    func getLocationBookMark() {
        getLocationUseCase.execute(memberSeq: memberSeq) { result in
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
    
    // MARK: - MOVE
    
    func moveLocation(from sourceIndex: Int, to destinationIndex: Int) {
        let movedLocation = locations.remove(at: sourceIndex)
        locations.insert(movedLocation, at: destinationIndex)
    }
    
    func putLocation() {
        let updateLocationSeqs = locations.enumerated().map { index, location in
            PutFavoriteLocationBody(locationSeq: location.locationSeq, sequence: index)
        }
        
        putLocationUseCase.execute(request: updateLocationSeqs) { result in
            switch result {
            case .success:
                self.onUpdateLocationSuccess?()
            case .failure(let error):
                self.onUpdateLocationFailure?(error.localizedDescription)
            }
        }
    }
    
    // MARK: - SELECT
    
    // 위치가 선택되었는지 확인
    func isLocationChecked(at index: Int) -> Bool {
        return checkedLocations.contains(index)
    }
    
    // 위치 선택 상태를 토글
    func toggleLocationCheck(at index: Int) {
        if checkedLocations.contains(index) {
            checkedLocations.remove(index)
        } else {
            checkedLocations.insert(index)
        }
        
        onSelectionChanged?(hasSelectedLocations)
    }
    
    // MARK: - DELETE
    
    func deleteLocations(at indexes: [Int]) {
        for index in indexes.sorted(by: >) {
            locations.remove(at: index)
        }
        checkedLocations.removeAll()
    }
    
    func deleteSelectedLocations() {
        let locationSeqs = checkedLocations.map { locations[$0].locationSeq }
        let request = DeleteFavoriteLocationBody(memberSeq: UserDefaultsManager.shared.getMemberSeq(), locationSeqs: locationSeqs)
        
        deleteLocationUseCase.execute(request: request) { [weak self] result in
            switch result {
            case .success:
                self?.locations.removeAll { location in
                    locationSeqs.contains(location.locationSeq)
                }
                self?.checkedLocations.removeAll()
                self?.onDeleteLocationSuccess?()
                
            case .failure(let error):
                self?.onDeleteLocationFailure?(error)
            }
        }
    }
}
