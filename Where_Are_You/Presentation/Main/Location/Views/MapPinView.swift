//
//  FriendsLocationView.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import SwiftUI
import KakaoMapsSDK

struct MapPinView: View {
    @State var draw: Bool = false // 뷰의 appear 상태를 전달하기 위한 변수.
    @Binding var myLocation: LongLat
    @Binding var friendsLocation: [LongLat]
    
    var body: some View {
        KakaoMapPinView(draw: $draw, myLocation: $myLocation, friendsLocation: $friendsLocation)
            .onAppear(perform: {
                self.draw = true
            })
            .onDisappear(perform: { self.draw = false })
            .ignoresSafeArea()
    }
}

struct KakaoMapPinView: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var myLocation: LongLat
    @Binding var friendsLocation: [LongLat]
    
    /// UIView를 상속한 KMViewContainer를 생성한다.
    /// 뷰 생성과 함께 KMControllerDelegate를 구현한 Coordinator를 생성하고, 엔진을 생성 및 초기화한다.
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        return view
    }
    
    /// Updates the presented `UIView` (and coordinator) to the latest configuration.
    /// draw가 true로 설정되면 엔진을 시작하고 렌더링을 시작한다.
    /// draw가 false로 설정되면 렌더링을 멈추고 엔진을 stop한다.
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                guard let controller = context.coordinator.controller else {
                    print("Controller is nil in updateUIView")
                    return
                }
                
                if !controller.isEnginePrepared {
                    controller.prepareEngine()
                    
                    // 엔진 준비 후 addViews 호출
                    context.coordinator.addViews()
                }
                
                if !controller.isEngineActive {
                    controller.activateEngine()
                }
                
                // location이 변경되었을 때 updateLocation 호출
                context.coordinator.updateLocation(myNewLocation: myLocation, friendsNewLocation: friendsLocation)
                print("📍KakaoMapPinView - updateUIView with location x: \(myLocation.x), y: \(myLocation.y)")
            }
        } else {
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
        
        // Poi생성을 위한 LabelLayer 생성
        func createLabelLayer() {
            guard let controller else { return }
            
            guard let view = controller.getView(mapViewName) as? KakaoMap else { return }
            let manager = view.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
            let _ = manager.addLabelLayer(option: layerOption)
        }
        
        // Poi 표시 스타일 생성
        func createMyPoiStyle() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
            let manager = view.getLabelManager()
            
            if !createdStyleIDs.contains("myPoiStyle") {
                let myMarker = ProfileImageView(image: Image(myLocation?.member?.profileImage ?? "icon-profile-default"))
                let mySymbolImage = myMarker.snapshot().resizedForProfile(to: CGSize(width: LayoutAdapter.shared.scale(value: 30), height: LayoutAdapter.shared.scale(value: 40.667)))
                let myIconStyle = PoiIconStyle(symbol: mySymbolImage, anchorPoint: CGPoint(x: 0.5, y: 1))
                let myPoiStyle = PoiStyle(styleID: "myPoiStyle", styles: [
                    PerLevelPoiStyle(iconStyle: myIconStyle, level: 12)
                ])
                manager.addPoiStyle(myPoiStyle)
                createdStyleIDs.insert("myPoiStyle")
            }
        }

        func createFriendPoiStyles() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
            let manager = view.getLabelManager()
            
            for (index, friend) in friendsLocation.enumerated() {
                let styleID = "friendPoiStyle_\(index)"
                if !createdStyleIDs.contains(styleID) {
                    let profileImageName = friend.member?.profileImage ?? "icon-profile-default"
                    let friendMarker = ProfileImageView(image: Image(profileImageName))
                    let friendSymbolImage = friendMarker.snapshot().resizedForProfile(to: CGSize(width: LayoutAdapter.shared.scale(value: 30), height: LayoutAdapter.shared.scale(value: 40.667)))
                    let friendIconStyle = PoiIconStyle(symbol: friendSymbolImage, anchorPoint: CGPoint(x: 0.5, y: 1))
                    let friendPoiStyle = PoiStyle(styleID: styleID, styles: [
                        PerLevelPoiStyle(iconStyle: friendIconStyle, level: 12)
                    ])
                    manager.addPoiStyle(friendPoiStyle)
                    createdStyleIDs.insert(styleID)
                }
            }
        }
        
        private func createMyPoi() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap,
                  let layer = view.getLabelManager().getLabelLayer(layerID: "PoiLayer"),
                  let myLocation = myLocation else { return }
            
            let myPoiOption = PoiOptions(styleID: "myPoiStyle")
            myPoiOption.rank = 0
            myLocationPoi = layer.addPoi(
                option: myPoiOption,
                at: MapPoint(longitude: myLocation.x, latitude: myLocation.y)
            )
            myLocationPoi?.show()
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
        func updateLocation(myNewLocation: LongLat, friendsNewLocation: [LongLat]) {
            self.myLocation = myNewLocation
            self.friendsLocation = friendsNewLocation
            
            // view가 준비되지 않았으면 업데이트 스킵
            guard isViewReady else { return }
            guard let view = controller?.getView(mapViewName) as? KakaoMap else { return }
            
            // 각각의 스타일 생성 확인
            if !createdStyleIDs.contains("myPoiStyle") {
                createMyPoiStyle()
                createMyPoi()
            }
            if friendsPois.count != friendsNewLocation.count {
                createFriendPoiStyles()
                createFriendPois()
            }
            
            // 위치 업데이트
            if let myPoi = myLocationPoi as? Poi {
                myPoi.moveAt(MapPoint(longitude: myNewLocation.x, latitude: myNewLocation.y), duration: 0)
            }
            if friendsPois.count != friendsNewLocation.count {
                // 친구 수가 변경된 경우 POI 재생성
                createFriendPois()
            } else {
                // 친구 수가 동일한 경우 위치만 업데이트
                for (index, friend) in friendsNewLocation.enumerated() {
                    if let friendPoi = friendsPois[index] as? Poi {
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
