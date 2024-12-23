//
//  FriendsLocationViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 30.11.24.
//

import Foundation
import CoreLocation
import KakaoMapsSDK

struct LongLat {
    var member: Member?
    var x: Double
    var y: Double
}

class FriendsLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var myLocation = LongLat(x: 0, y: 0)
    @Published var friendsLocation: [LongLat] = []
    @Published var locationError: String?
    
    private var locationManager: CLLocationManager?
    private let postCoordinateUseCase: PostCoordinateUseCase
    private let getCoordinateUseCase: GetCoordinateUseCase
    private var locationUpdateTimer: Timer?
    
    var onLocationUpdate: (() -> Void)? // 위치 변화시 실행되는 콜백 함수
    
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
//        self.isNetworkSuccess = true
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
    
    // MARK: 5초마다 친구들 위치 업데이트 시작
    func startUpdatingFriendsLocation(schedule: Schedule) {
        locationUpdateTimer?.invalidate()
        getCoordinate(schedule: schedule)
        
        locationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            self?.getCoordinate(schedule: schedule)
        }
    }
    
    // MARK: 위치 업데이트 성공
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {  return  }
        
        DispatchQueue.main.async {
            self.locationError = nil
            self.myLocation.x = location.coordinate.longitude
            self.myLocation.y = location.coordinate.latitude
//            self.isNetworkSuccess = true
            
            print("위치 업데이트 성공 - longitude(x): \(location.coordinate.longitude), latitude(y): \(location.coordinate.latitude)")
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
        locationUpdateTimer?.invalidate()
        locationUpdateTimer = nil
    }
    
    // MARK: 서버 통신 - 사용자 위치 정보 보내기
    func postCoordinate(scheduleSeq: Int) {
        let memberSeq = UserDefaultsManager.shared.getMemberSeq()
        postCoordinateUseCase.execute(request: PostCoordinateBody(memberSeq: memberSeq, scheduleSeq: scheduleSeq, x: self.myLocation.x, y: self.myLocation.y)) { [weak self] result in
            switch result {
            case .success:
                self?.onLocationUpdate?()
                print("사용자 위치 정보 보내기 완료!")
            case .failure(let error):
                print("사용자 위치 정보 보내기 실패 - \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: 서버 통신 - 친구들 위치 정보 받기
    func getCoordinate(schedule: Schedule) {
        getCoordinateUseCase.execute(schedule: schedule) { [weak self] result in
            switch result {
            case .success(let responses):
                let locations = responses.map { response in
                    LongLat(member: Member(userName: response.userName, profileImage: response.profileImage, memberSeq: response.memberSeq),
                            x: response.x, y: response.y)
                }
                
                DispatchQueue.main.async {
                    print("Updating friends locations - count: \(locations.count)")
                    locations.forEach { location in
                        print("Friend location - x: \(location.x), y: \(location.y)")
                    }
                    self?.friendsLocation = locations
                    self?.onLocationUpdate?()
                }
                print("친구들 위치 정보 받기 완료! \(String(describing: self?.friendsLocation.description))")
            case .failure(let error):
                print("친구들 위치 정보 받기 실패 - \(error.localizedDescription)")
            }
        }
    }
}
