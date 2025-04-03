//
//  FriendsLocationView.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI
import KakaoMapsSDK
import Kingfisher

// TODO: 앱을 실행하고 처음으로 위치 확인 뷰를 열면 하얀색 화면만 보임. 그 상태에서 백그라운드로 보냈다가 다시 열면 잘 작동됨
// TODO: 버그 수정 후 디버깅 코드 삭제 필요
struct MapPinView: View {
    @State var draw: Bool = false // 뷰의 appear 상태를 전달하기 위한 변수.
    @Binding var myLocation: LongLat
    @Binding var friendsLocation: [LongLat]
    @State private var debugMessage: String = "초기화 중..."
    @State private var showDebug: Bool = true // 디버깅용 - 실제 앱에서는 false로 설정
    
    var body: some View {
//        KakaoMapPinView(draw: $draw, myLocation: $myLocation, friendsLocation: $friendsLocation)
//            .onAppear(perform: {
//                self.draw = true
//            })
//            .onDisappear(perform: { self.draw = false })
//            .ignoresSafeArea()
        
        KakaoMapPinView(draw: $draw, myLocation: $myLocation, friendsLocation: $friendsLocation, debugMessage: $debugMessage)
                        .onAppear {
                            print("📍 MapPinView appeared")
                            self.draw = true
                        }
                        .onDisappear {
                            print("📍 MapPinView disappeared")
                            self.draw = false
                        }
                        .ignoresSafeArea()
        
        // 디버깅 오버레이 (문제 해결 후 제거)
        if showDebug {
            VStack {
                Text(debugMessage)
                    .padding(8)
                    .background(Color.black.opacity(0.7))
                    .foregroundColor(.white)
                    .cornerRadius(5)
                    .padding()
                Spacer()
            }
        }
    }
}

struct KakaoMapPinView: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var myLocation: LongLat
    @Binding var friendsLocation: [LongLat]
    @Binding var debugMessage: String
    
    private func setDebug(_ message: String) {
        print("📍 \(message)")
        DispatchQueue.main.async {
            self.debugMessage = message
        }
    }
    
    /// UIView를 상속한 KMViewContainer를 생성한다.
    /// 뷰 생성과 함께 KMControllerDelegate를 구현한 Coordinator를 생성하고, 엔진을 생성 및 초기화한다.
    func makeUIView(context: Self.Context) -> KMViewContainer {
        setDebug("makeUIView 호출됨")
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        return view
    }
    
    /// Updates the presented `UIView` (and coordinator) to the latest configuration.
    /// draw가 true로 설정되면 엔진을 시작하고 렌더링을 시작한다.
    /// draw가 false로 설정되면 렌더링을 멈추고 엔진을 stop한다.
//    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
//        if draw {
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                guard let controller = context.coordinator.controller else {
//                    print("Controller is nil in updateUIView")
//                    return
//                }
//                
//                // 항상 POI 정리를 먼저 수행
//                context.coordinator.cleanUpPois()
//                
//                if !controller.isEnginePrepared {
//                    controller.prepareEngine()
//                    context.coordinator.addViews() // 엔진 준비 후 addViews 호출
//                }
//                
//                if !controller.isEngineActive {
//                    controller.activateEngine()
//                }
//                
//                // location이 변경되었을 때 updateLocation 호출
//                context.coordinator.updateLocation(myNewLocation: myLocation, friendsNewLocation: friendsLocation)
//                print("📍KakaoMapPinView - updateUIView with location x: \(myLocation.x), y: \(myLocation.y)")
//            }
//        } else {
//            context.coordinator.cleanUpPois() // 모든 Poi 제거
//            context.coordinator.controller?.resetEngine()
//            print("📍KakaoMapPinView - 뷰 사라짐, 모든 리소스 정리")
//        }
//    }
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        setDebug("updateUIView 호출됨 (draw: \(draw))")
        
        if draw {
            // 엔진 상태 확인 및 설정
            DispatchQueue.main.async {
                let controller = context.coordinator.controller
                setDebug("컨트롤러: \(controller != nil ? "OK" : "nil")")
                
                if let controller = controller {
                    if !controller.isEnginePrepared {
                        setDebug("엔진 준비 시작")
                        controller.prepareEngine()
                        
                        // 후속 작업을 위한 지연 추가
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if controller.isEnginePrepared {
                                setDebug("엔진 준비 완료")
                                context.coordinator.addViews()
                                
                                if !controller.isEngineActive {
                                    setDebug("엔진 활성화 중")
                                    controller.activateEngine()
                                }
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    setDebug("위치 업데이트 시도")
                                    context.coordinator.updateLocation(myNewLocation: myLocation, friendsNewLocation: friendsLocation)
                                }
                            } else {
                                setDebug("❌ 엔진 준비 실패")
                            }
                        }
                    } else if !controller.isEngineActive {
                        setDebug("엔진 활성화 중")
                        controller.activateEngine()
                        context.coordinator.updateLocation(myNewLocation: myLocation, friendsNewLocation: friendsLocation)
                    } else {
                        setDebug("이미 준비됨, 위치 업데이트")
                        context.coordinator.updateLocation(myNewLocation: myLocation, friendsNewLocation: friendsLocation)
                    }
                }
            }
        } else {
            setDebug("엔진 비활성화")
            context.coordinator.cleanUpPois()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    /// Coordinator 생성
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(myLocation: myLocation, friendsLocation: friendsLocation)
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
    
    /// Coordinator 구현. KMControllerDelegate를 adopt한다.
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        var controller: KMController?
        var container: KMViewContainer?
        var myLocation: LongLat?
        var friendsLocation: [LongLat]
        
        // POI 객체들을 저장 -> 이미 생성된 POI는 위치 업데이트만 할 수 있도록
        private var myLocationPoi: KakaoMapsSDK.Label?
        private var friendsPois: [KakaoMapsSDK.Label] = []
        private var createdStyleIDs: Set<String> = [] // 스타일을 한번만 생성하도록 각 스타일의 생성 여부 추적
        
        private let mapViewName = "friendsLocationMapView"
        private var isViewReady = false
        
        init(myLocation: LongLat?, friendsLocation: [LongLat]) {
            self.myLocation = myLocation
            self.friendsLocation = friendsLocation
            super.init()
        }
        
        // KMController 객체 생성 및 event delegate 지정
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        // 엔진 생성 및 초기화 이후, 렌더링 준비가 완료되면 아래 addViews를 호출한다.
        // 원하는 뷰를 생성한다.
        func addViews() {
            let defaultPosition: MapPoint
            if let myLocation {
                defaultPosition = MapPoint(longitude: myLocation.x, latitude: myLocation.y)
            } else {
                defaultPosition = MapPoint(longitude: 126.978365, latitude: 37.566691)
            }
            
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: mapViewName, viewInfoName: "map", defaultPosition: defaultPosition)
            
            guard let controller else {
                print("Controller is nil in addViews")
                return
            }
            
            controller.addView(mapviewInfo)
        }
        
        // addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            guard let view = controller?.getView(viewName) else {
                print("view not found in addViewSucceeded")
                return
            }
            view.viewRect = container?.bounds ?? .zero
            
            createLabelLayer()
            
            createMyPoiStyle()
            createFriendPoiStyles()
            
            createMyPoi()
            createFriendPois()
            
            // view가 성공적으로 추가되었음을 표시
            isViewReady = true
            
            // 현재 location으로 카메라 위치 업데이트
            if let currentLocation = myLocation {
                updateLocation(myNewLocation: currentLocation, friendsNewLocation: friendsLocation)
            }
        }
        
        // addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
        func addViewFailed(_ viewName: String, viewInfoName: String) {
            print("Failed to add view")
        }
        
        func authenticationSucceeded() {
            print("auth succeed!!")
            if let controller = controller,
               !controller.isEngineActive {
                controller.activateEngine()
            }
        }
        
        func authenticationFailed(_ errorCode: Int, desc: String) {
            print("auth failed")
            print("error code: \(errorCode)")
            print(desc)
        }
        
        func cleanUpPois(cleanMyLocation: Bool = true, cleanFriends: Bool = true) {
            guard let view = controller?.getView(mapViewName) as? KakaoMap,
                  let layer = view.getLabelManager().getLabelLayer(layerID: "PoiLayer") else { return }
            
            // 내 위치 마커 제거
            if cleanMyLocation, let existingPoi = myLocationPoi {
                layer.removePoi(poiID: existingPoi.itemID)
                myLocationPoi = nil
                print("📍내 위치 마커 제거됨")
            }
            
            // 친구 마커 제거
            if cleanFriends {
                for friend in friendsPois {
                    layer.removePoi(poiID: friend.itemID)
                }
                friendsPois.removeAll()
                print("📍친구 마커 모두 제거됨: \(friendsPois.count)")
            }
        }
        
        // Poi생성을 위한 LabelLayer 생성
        func createLabelLayer() {
            guard let controller else { return }
            
            guard let view = controller.getView(mapViewName) as? KakaoMap else { return }
            let manager = view.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 5000)
            let _ = manager.addLabelLayer(option: layerOption)
        }
        
        // Poi 표시 스타일 생성
        func createMyPoiStyle() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
            let manager = view.getLabelManager()
            
            if !createdStyleIDs.contains("myPoiStyle") {
                let imageURL = URL(string: UserDefaultsManager.shared.getProfileImage()) ?? URL(string: AppConstants.defaultProfileImageUrl)!
                
                downloadProfileImage(from: imageURL) { [weak self] swiftUIImage in
                    guard let self = self else { return }
                    
                    let myMarker = ProfileImageView(image: swiftUIImage)
                    let mySymbolImage = myMarker.snapshot()
                        .resizedForProfile(to: CGSize(width: LayoutAdapter.shared.scale(value: 30), height: LayoutAdapter.shared.scale(value: 44)))
                    let myIconStyle = PoiIconStyle(symbol: mySymbolImage, anchorPoint: CGPoint(x: 0.5, y: 1))
                    let myPoiStyle = PoiStyle(styleID: "myPoiStyle", styles: [
                        PerLevelPoiStyle(iconStyle: myIconStyle, level: 12)
                    ])
                    
                    manager.addPoiStyle(myPoiStyle)
                    self.createdStyleIDs.insert("myPoiStyle")
                    print("마커 스타일 추가됨: myPoiStyle")
                    
                    // 스타일 생성 완료 후 POI 생성
                    self.createMyPoi()
                }
            }
        }

        func createFriendPoiStyles() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
            let manager = view.getLabelManager()
            
            for (index, friend) in friendsLocation.enumerated() {
                let styleID = "friendPoiStyle_\(index)"
                if !createdStyleIDs.contains(styleID) {
                    let imageURL = URL(string: friend.member?.profileImage ?? AppConstants.defaultProfileImageUrl)!
                    
                    downloadProfileImage(from: imageURL) { [weak self] swiftUIImage in
                        guard let self = self else { return }
                        
                        let friendMarker = ProfileImageView(image: swiftUIImage)
                        let friendSymbolImage = friendMarker.snapshot().resizedForProfile(to: CGSize(width: LayoutAdapter.shared.scale(value: 30), height: LayoutAdapter.shared.scale(value: 44)))
                        let friendIconStyle = PoiIconStyle(symbol: friendSymbolImage, anchorPoint: CGPoint(x: 0.5, y: 1))
                        let friendPoiStyle = PoiStyle(styleID: styleID, styles: [
                            PerLevelPoiStyle(iconStyle: friendIconStyle, level: 12)
                        ])
                        
                        manager.addPoiStyle(friendPoiStyle)
                        createdStyleIDs.insert(styleID)
                        print("마커 스타일 추가됨: myPoiStyle")
                    }
                }
            }
            
            // 스타일 생성 완료 후 POI 생성
            self.createMyPoi()
        }
        
        private func downloadProfileImage(from url: URL, completion: @escaping (Image) -> Void) {
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success(let imageResult):
                    let swiftUIImage = Image(uiImage: imageResult.image)
                    completion(swiftUIImage)
                case .failure:
                    let defaultImage = Image("icon-profile-default")
                    completion(defaultImage)
                }
            }
        }
        
        private func createMyPoi() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap,
                  let layer = view.getLabelManager().getLabelLayer(layerID: "PoiLayer"),
                  let myLocation = myLocation else { return }
            
            // 반드시 기존 마커 확인 및 제거
            if let existingPoi = myLocationPoi {
                layer.removePoi(poiID: existingPoi.itemID)
                myLocationPoi = nil
                print("📍createMyPoi에서 기존 마커 제거됨")
            }
            
            let myPoiOption = PoiOptions(styleID: "myPoiStyle")
            myPoiOption.rank = 0
            myLocationPoi = layer.addPoi(
                option: myPoiOption,
                at: MapPoint(longitude: myLocation.x, latitude: myLocation.y)
            )
            myLocationPoi?.show()
            print("📍새 내 위치 마커 생성됨")
        }
        
        private func createFriendPois() {
            print("📍Creating friend POIs, count: \(friendsLocation.count)")
            guard let view = controller?.getView(mapViewName) as? KakaoMap,
                  let layer = view.getLabelManager().getLabelLayer(layerID: "PoiLayer") else { return }
            
            // 기존 POI 제거
            for friend in friendsPois {
                layer.removePoi(poiID: friend.itemID)
            }
            friendsPois.removeAll()
            print("📍createFriendPois에서 기존 친구 마커 제거됨")
            
            // 친구 POI 생성
            for (index, friend) in friendsLocation.enumerated() {
                let friendPoiOption = PoiOptions(styleID: "friendPoiStyle_\(index)")
                friendPoiOption.rank = 1
                if let poi = layer.addPoi(
                    option: friendPoiOption,
                    at: MapPoint(longitude: friend.x, latitude: friend.y)
                ) {
                    friendsPois.append(poi)
                    poi.show()
                } else {
                    print("📍Failed to create friend POI \(index)")
                }
            }
        }

        private func updateMyPoi() {
            guard let myLocation = myLocation else { return }
            
            cleanUpPois(cleanMyLocation: true, cleanFriends: false) // 기존 마커가 있으면 제거
            createMyPoi() // 새 마커 생성
        }

        private func updateFriendPois() {
            cleanUpPois(cleanMyLocation: false, cleanFriends: true) // 기존 마커 제거
            createFriendPois() // 새 마커 생성
        }
        
        // KMViewContainer 리사이징 될 때 호출.
        func containerDidResized(_ size: CGSize) {
            guard let mapView = controller?.getView(mapViewName) as? KakaoMap else {
                print("mapView not found in containerDidResized")
                return
            }
            mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            
            let cameraUpdate = CameraUpdate.make(
                target: MapPoint(
                    longitude: myLocation?.x ?? 126.978365,
                    latitude: myLocation?.y ?? 37.566691
                ),
                mapView: mapView
            )
            mapView.moveCamera(cameraUpdate)
        }
        
        // location 값이 변경될 때 지도 업데이트를 위한 메서드 추가
//        func updateLocation(myNewLocation: LongLat, friendsNewLocation: [LongLat]) {
//            self.myLocation = myNewLocation
//            self.friendsLocation = friendsNewLocation
//            
//            // view가 준비되지 않았으면 업데이트 스킵
//            guard isViewReady else { return }
//            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
//            
//            // 각각의 스타일 생성 확인
//            if !createdStyleIDs.contains("myPoiStyle") {
//                createMyPoiStyle()
//                createMyPoi()
//            }
//            if friendsPois.count != friendsNewLocation.count {
//                createFriendPoiStyles()
//                createFriendPois()
//            }
//            
//            // 위치 업데이트
//            if let myPoi = myLocationPoi as? Poi {
//                myPoi.moveAt(MapPoint(longitude: myNewLocation.x, latitude: myNewLocation.y), duration: 0)
//            }
//            if friendsPois.count != friendsNewLocation.count {
//                // 친구 수가 변경된 경우 POI 재생성
//                createFriendPois()
//            } else {
//                // 친구 수가 동일한 경우 위치만 업데이트
//                for (index, friend) in friendsNewLocation.enumerated() {
//                    if let friendPoi = friendsPois[index] as? Poi {
//                        friendPoi.moveAt(MapPoint(longitude: friend.x, latitude: friend.y), duration: 0)
//                    }
//                }
//            }
//            
//            // 카메라 이동: 내 위치 중심
//            let target = MapPoint(longitude: myNewLocation.x, latitude: myNewLocation.y)
//            let cameraUpdate = CameraUpdate.make(
//                target: target,
//                zoomLevel: 16, mapView: view
//            )
//            view.moveCamera(cameraUpdate)
//            print("📍MapPinView camera updated! x: \(myNewLocation.x), y: \(myNewLocation.y)")
//        }
        
        // location 값이 변경될 때 지도 업데이트를 위한 메서드 추가
        func updateLocation(myNewLocation: LongLat, friendsNewLocation: [LongLat]) {
            self.myLocation = myNewLocation
            self.friendsLocation = friendsNewLocation
            
            // view가 준비되지 않았으면 업데이트 스킵
            guard isViewReady else { return }
            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
            
            // 내 위치 POI 처리
            if !createdStyleIDs.contains("myPoiStyle") {
                // 스타일이 없으면 스타일 생성 (POI는 스타일 생성 콜백에서 생성됨)
                createMyPoiStyle()
            } else if let myPoi = myLocationPoi as? Poi {
                // 스타일이 이미 있고 POI도 있으면 위치만 업데이트
                myPoi.moveAt(MapPoint(longitude: myNewLocation.x, latitude: myNewLocation.y), duration: 0)
            } else {
                // 스타일은 있지만 POI가 없으면 POI만 생성
                updateMyPoi()
            }
            
            // 친구 POI 처리
            let needsRecreate = friendsPois.count != friendsNewLocation.count
            
            // 친구 스타일 생성 필요 확인
            for (index, _) in friendsNewLocation.enumerated() {
                let styleID = "friendPoiStyle_\(index)"
                if !createdStyleIDs.contains(styleID) {
                    createFriendPoiStyles()
                    break
                }
            }
            
            if needsRecreate {
                // 친구 수가 변경된 경우 POI 모두 재생성
                updateFriendPois()
            } else {
                // 친구 수가 동일한 경우 위치만 업데이트
                for (index, friend) in friendsNewLocation.enumerated() {
                    if index < friendsPois.count, let friendPoi = friendsPois[index] as? Poi {
                        friendPoi.moveAt(MapPoint(longitude: friend.x, latitude: friend.y), duration: 0)
                    }
                }
            }
            
            // 카메라 이동: 내 위치 중심
            let target = MapPoint(longitude: myNewLocation.x, latitude: myNewLocation.y)
            let cameraUpdate = CameraUpdate.make(
                target: target,
                zoomLevel: 16, mapView: view
            )
            view.moveCamera(cameraUpdate)
            print("📍MapPinView camera updated! x: \(myNewLocation.x), y: \(myNewLocation.y)")
        }
    }
}

#Preview {
    MapPinView(
        myLocation: .constant(LongLat(member: Member(userName: "김주희", profileImage: "exampleProfileImage"), x: 127.0388462, y: 37.495418)),
        friendsLocation: .constant([
            LongLat(member: Member(userName: "최수빈", profileImage: "exampleBanner2"), x: 127.0398462, y: 37.496418),  // 약 100-200m 차이
            LongLat(member: Member(userName: "이민혁", profileImage: "icon-profile-default"), x: 127.0378462, y: 37.494418),  // 약 100-200m 차이
            LongLat(member: Member(userName: "강사랑", profileImage: "exampleBanner"), x: 127.0388462, y: 37.497418)   // 약 200m 차이
        ])
    )
}
