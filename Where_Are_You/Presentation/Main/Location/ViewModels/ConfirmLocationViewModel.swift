//
//  ConfirmLocationViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 09.09.24.
//

import Foundation
import Moya
import CoreLocation

class ConfirmLocationViewModel: ObservableObject {
    let provider = MoyaProvider<LocationAPI>()
    @Published var isFavorite = false
    private let geocoder = CLGeocoder()
    let memberSeq = 1 // TODO: 실제 사용 시에는 현재 로그인한 사용자의 memberSeq를 사용
    
    func convertingAddressToCoord(address: String, completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void) {
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                completion(.failure(NSError(domain: "ConversionError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to get location from address"])))
                return
            }
            
            let coordinate = location.coordinate
            completion(.success(coordinate))
        }
    }
    
    func isFavoriteLocation(location: Location, completion: @escaping (Bool) -> Void) {
        provider.request(.getLocation(memberSeq: memberSeq)) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<GetFavLocationResponse>.self, from: response.data)
                        
                        let favLocations = genericResponse.data.map { loc in
                            Location(
                                sequence: loc.locationSeq,
                                location: loc.location,
                                streetName: loc.streetName,
                                x: 0,
                                y: 0)
                        }
                        print("즐겨찾기 위치 로드 성공: \(favLocations.count)개의 위치를 받았습니다.")
                        let isFav = favLocations.contains { $0.streetName == location.streetName }
                        DispatchQueue.main.async {
                            self.isFavorite = isFav
                            completion(isFav)
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
                print("요청 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    func toggleFavorite(location: Location) {
        isFavoriteLocation(location: location) { [weak self] isFavorite in
            guard let self = self else { return }
            
            if isFavorite {
                self.deleteFavorite(location: location) { success in
                    DispatchQueue.main.async {
                        if success {
                            self.isFavorite = false
                        } else {
                            print("즐겨찾기 삭제 실패")
                        }
                    }
                }
            } else {
                self.addFavorite(location: location) { success in
                    DispatchQueue.main.async {
                        if success {
                            self.isFavorite = true
                        } else {
                            print("즐겨찾기 추가 실패")
                        }
                    }
                }
            }
        }
    }
    
    private func addFavorite(location: Location, completion: @escaping (Bool) -> Void) {
        provider.request(.postLocation(request: PostFavoriteLocationBody(memberSeq: memberSeq, location: location.location, streetName: location.streetName))) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        let genericResponse = try decoder.decode(GenericResponse<PostFavLocation>.self, from: response.data)
                        
                        let locationSeq = genericResponse.data.locationSeq
                        print("즐겨찾기 추가 성공: 위치 시퀀스 넘버는 \(locationSeq)입니다.")
                        completion(true)
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
                print("요청 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
    
    private func deleteFavorite(location: Location, completion: @escaping (Bool) -> Void) {
        provider.request(.deleteLocation(request: DeleteFavoriteLocationBody(memberSeq: memberSeq, locationSeqs: [location.sequence]))) { result in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    print("즐겨찾기 삭제 성공")
                    completion(true)
                } else {
                    print("서버 오류: \(response.statusCode)")
                    completion(false)
                }
            case .failure(let error):
                print("요청 실패: \(error.localizedDescription)")
                completion(false)
            }
        }
    }
}
