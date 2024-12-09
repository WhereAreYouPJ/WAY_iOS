//
//  FriendsLocationViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 30.11.24.
//

import Foundation
import CoreLocation
import KakaoMapsSDK

class FriendsLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLongitude: Double = 0
    @Published var userLatitude: Double = 0
    @Published var locationError: String?
    
    private var locationManager: CLLocationManager?
    private let postCoordinateUseCase: PostCoordinateUseCase
    private let getCoordinateUseCase: GetCoordinateUseCase
    
    init(
        postCoordinateUseCase: PostCoordinateUseCase,
        getCoordinateUseCase: GetCoordinateUseCase
    ) {
        self.postCoordinateUseCase = postCoordinateUseCase
        self.getCoordinateUseCase = getCoordinateUseCase
        super.init()
        setupLocationManager()
    }
    
    // MARK: Location Manager 설정 시작
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.distanceFilter = kCLDistanceFilterNone
        
        DispatchQueue.global().async { [weak self] in
            self?.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: 위치 권한 상태 변경 콜백
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("위치 권한 상태 변경됨")
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("권한 상태: 허용됨")
            startUpdatingLocation()
        case .denied, .restricted:
            print("권한 상태: 제한됨 또는 거부됨")
            DispatchQueue.main.async {
                self.locationError = "위치 서비스 권한이 거부되었습니다."
            }
        case .notDetermined:
            print("권한 상태: 미결정")
        @unknown default:
            break
        }
    }
    
    // MARK: 위치 업데이트 시작
    func startUpdatingLocation() {
        DispatchQueue.global().async { [weak self] in
            if CLLocationManager.locationServicesEnabled() {
                self?.locationManager?.startUpdatingLocation()
            } else {
                print("위치 서비스가 비활성화되어 있습니다")
                DispatchQueue.main.async {
                    self?.locationError = "위치 서비스가 꺼져 있습니다. 설정에서 위치 서비스를 켜주세요."
                }
            }
        }
    }
    
    // MARK: 위치 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {  return  }
        
        print("위치 업데이트 성공 - 위도: \(location.coordinate.latitude), 경도: \(location.coordinate.longitude)")
        
        DispatchQueue.main.async {
            self.locationError = nil
            self.userLatitude = location.coordinate.latitude
            self.userLongitude = location.coordinate.longitude
            self.postCoordinate()
        }
    }
    
    // MARK: 위치 업데이트 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("위치 업데이트 실패 상세: \(error)")
        
        DispatchQueue.main.async {
            self.locationError = "위치 정보를 가져오는데 실패했습니다: \(error.localizedDescription)"
        }
    }
    
    // MARK: 위치 업데이트 중지
    func stopUpdatingLocation() {
        print("위치 업데이트 중지")
        locationManager?.stopUpdatingLocation()
    }
    
    // MARK: 서버 통신 - 사용자 위치 정보 보내기
    func postCoordinate() {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        postCoordinateUseCase.execute(request: PostCoordinateBody(memberSeq: memberSeq, scheduleSeq: 1, x: self.userLongitude, y: self.userLatitude)) { result in
            switch result {
            case .success:
                print("사용자 위치 정보 보내기 완료!")
            case .failure(let error):
                print("사용자 위치 정보 보내기 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 서버 통신 - 친구들 위치 정보 받기
    func getCoordinate() {
        getCoordinateUseCase.execute(scheduleSeq: 1) { result in // TODO: 실제 스케줄시퀀스 넘겨받기
            switch result {
            case .success:
                print("친구들 위치 정보 받기 완료!")
            case .failure(let error):
                print("친구들 위치 정보 받기 실패 - \(error.localizedDescription)")
            }
        }
    }
}
