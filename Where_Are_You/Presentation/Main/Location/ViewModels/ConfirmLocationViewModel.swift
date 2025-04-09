//
//  ConfirmLocationViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 09.09.24.
//

import Foundation

class ConfirmLocationViewModel: ObservableObject { // TODO: 위치 시퀀스 오류. 직전에 선택한 장소 말고 이전에 즐겨찾기해둔 장소 선택하면 시퀀스 0으로 뜨는 문제
    @Published var isFavorite = false
    @Published var location: Location
    
    let member = Member(userName: UserDefaultsManager.shared.getUserName() ?? "나",
                        profileImage: UserDefaultsManager.shared.getProfileImage())
    let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    
    private let getFavoriteLocationUseCase: GetLocationUseCase
    private let postFavoriteLocationUseCase: PostLocationUseCase
    private let deleteFavoriteLocationUseCase: DeleteLocationUseCase
    
    init(
        location: Location,
        getFavoriteLocationUseCase: GetLocationUseCase,
        postFavoriteLocationUseCase: PostLocationUseCase,
        deleteFavoriteLocationUseCase: DeleteLocationUseCase
    ) {
        self.location = location
        self.getFavoriteLocationUseCase = getFavoriteLocationUseCase
        self.postFavoriteLocationUseCase = postFavoriteLocationUseCase
        self.deleteFavoriteLocationUseCase = deleteFavoriteLocationUseCase
    }
    
    func isFavoriteLocation() {
        getFavoriteLocationUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let favLocations):
                    if let matchedLocation = favLocations.first(where: {
                        $0.streetName == self?.location.streetName &&
                        $0.location == self?.location.location
                    }) {
                        self?.location = Location(
                            locationSeq: matchedLocation.locationSeq,
                            sequence: matchedLocation.sequence,
                            location: matchedLocation.location,
                            streetName: matchedLocation.streetName,
                            x: matchedLocation.x,
                            y: matchedLocation.y
                        )
                        self?.isFavorite = true
                    } else {
                        self?.isFavorite = false
                    }
                    print("isFavoriteLocation 조회 성공")
                case .failure:
                    print("isFavoriteLocation 조회 실패")
                }
            }
        }
    }
    
    func toggleFavorite() {
        print("위치 시퀀스: \(self.location.sequence)")
        if isFavorite {
            deleteFavorite { success in
                DispatchQueue.main.async {
                    if success {
                        self.isFavorite = false
                    }
                }
            }
        } else {
            addFavorite { success in
                DispatchQueue.main.async {
                    if success {
                        self.isFavorite = true
                        print("위치 즐겨찾기 성공! 좌표: ", self.location.x, self.location.y)
                    }
                }
            }
        }
    }
    
    private func addFavorite(completion: @escaping (Bool) -> Void) {
        let postBody = PostFavoriteLocationBody(
            memberSeq: self.memberSeq,
            location: location.location,
            streetName: location.streetName,
            x: location.x,
            y: location.y
        )
        
        postFavoriteLocationUseCase.execute(request: postBody) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.location.locationSeq = response.data.locationSeq
                    self.location.sequence = 0
                    print("즐겨찾기 추가 성공! 위치 시퀀스: \(self.location.locationSeq ?? 0)")
                    completion(true)
                case .failure:
                    print("즐겨찾기 추가 실패")
                    completion(false)
                }
            }
        }
    }
    
    private func deleteFavorite(completion: @escaping (Bool) -> Void) {
        let deleteBody = DeleteFavoriteLocationBody(
            memberSeq: self.memberSeq,
            locationSeqs: [self.location.locationSeq ?? 0]
        )
        
        deleteFavoriteLocationUseCase.execute(request: deleteBody) { result in
            switch result {
            case .success:
                print("즐겨찾기 삭제 성공")
                completion(true)
            case .failure:
                print("즐겨찾기 삭제 실패")
                completion(false)
            }
        }
    }
}
