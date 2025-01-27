//
//  ConfirmLocationViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 09.09.24.
//

import Foundation
import Moya

class ConfirmLocationViewModel: ObservableObject {
    @Published var isFavorite = false
    
    let provider = MoyaProvider<LocationAPI>()
    let memberSeq = UserDefaultsManager.shared.getMemberSeq()
    private var currentLocationSeq: Int?
    
    func isFavoriteLocation(location: Location, completion: @escaping (Bool) -> Void) {
        provider.request(.getLocation(memberSeq: memberSeq)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<GetFavLocationResponse>.self, from: response.data)
                        
                        let favLocations = genericResponse.data
                        print("즐겨찾기 위치 로드 성공: \(favLocations.count)개의 위치를 받았습니다.")
                        if let matchingLocation = favLocations.first(where: { $0.streetName == location.streetName }) {
                            self.currentLocationSeq = matchingLocation.locationSeq
                            DispatchQueue.main.async {
                                self.isFavorite = true
                                completion(true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.isFavorite = false
                                self.currentLocationSeq = nil
                                completion(false)
                            }
                        }
                    } catch {
                        print("JSON 디코딩 실패: \(error.localizedDescription)")
                        completion(false)
                    }
                } else {
                    print("서버 오류: \(response.statusCode)")
                    if let json = try? response.mapJSON() as? [String: Any],
                       let detail = json["detail"] as? String {
                        print("상세 메시지: \(detail)")
                    }
                    completion(false)
                }
            case .failure(let error):
                print("isFavoriteLocation 요청 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func toggleFavorite(location: Location, completion: @escaping (Bool) -> Void) {
        if isFavorite {
            deleteFavorite { success in
                DispatchQueue.main.async {
                    if success {
                        self.isFavorite = false
                        self.currentLocationSeq = nil
                    }
                    completion(success)
                }
            }
        } else {
            addFavorite(location: location) { success, newSeq in
                DispatchQueue.main.async {
                    if success {
                        self.isFavorite = true
                        self.currentLocationSeq = newSeq
                    }
                    completion(success)
                }
            }
        }
    }
    
    private func addFavorite(location: Location, completion: @escaping (Bool, Int?) -> Void) {
        provider.request(.postLocation(request: PostFavoriteLocationBody(memberSeq: memberSeq, location: location.location, streetName: location.streetName))) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<PostFavLocation>.self, from: response.data)
                        let newSeq = genericResponse.data.locationSeq
                        print("즐겨찾기 추가 성공. 새 locationSeq: \(newSeq)")
                        completion(true, newSeq)
                    } catch {
                        print("JSON 디코딩 실패: \(error.localizedDescription)")
                        completion(false, nil)
                    }
                } else {
                    print("서버 오류: \(response.statusCode)")
                    completion(false, nil)
                }
            case .failure(let error):
                print("addFavorite 요청 실패: \(error.localizedDescription)")
                completion(false, nil)
            }
        }
    }
    
    private func deleteFavorite(completion: @escaping (Bool) -> Void) {
        guard let locationSeq = currentLocationSeq else {
            print("삭제할 locationSeq가 없습니다.")
            completion(false)
            return
        }
        
        provider.request(.deleteLocation(request: DeleteFavoriteLocationBody(memberSeq: memberSeq, locationSeqs: [locationSeq]))) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    print("즐겨찾기 삭제 성공. 삭제된 locationSeq: \(locationSeq)")
                    completion(true)
                } else {
                    print("서버 오류: \(response.statusCode)")
                    completion(false)
                }
            case .failure(let error):
                print("deleteFavorite 요청 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
