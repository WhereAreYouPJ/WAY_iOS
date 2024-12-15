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
                    print("Engine prepared and views added")
                }
                
                if !controller.isEngineActive {
                    controller.activateEngine()
                }
                
                // location이 변경되었을 때 updateLocation 호출
                context.coordinator.updateLocation(myNewLocation: myLocation, friendsNewLocation: friendsLocation)
                print("KakaoMapPinView - updateUIView with location x: \(myLocation.x), y: \(myLocation.y)")
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
                print("MapPinView - x: \(myLocation.x), y: \(myLocation.y)")
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
            print("addViewSucceeded called for \(viewName), \(viewInfoName)")
            guard let view = controller?.getView(viewName) else {
                print("view not found in addViewSucceeded")
                return
            }
            view.viewRect = container?.bounds ?? .zero
            
            createLabelLayer()
            createPoiStyle()
            createPois()
            
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
            guard let controller else {
                print("Controller is nil in createLabelLayer")
                return
            }
            
            guard let view = controller.getView(mapViewName) as? KakaoMap else {
                print("view is nil or not KakaoMap type in createLabelLayer")
                return
            }
            let manager = view.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
            let _ = manager.addLabelLayer(option: layerOption)
        }
        
        // Poi 표시 스타일 생성
        func createPoiStyle() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap else {
                print("view is nil in createPoiStyle")
                return
            }
            let manager = view.getLabelManager()
            
            //            let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "icon-map-pin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
            //            let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "icon-map-pin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
            //            let iconStyle2 = PoiIconStyle(symbol: UIImage(named: "icon-map-pin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let myNoti = PoiBadge(badgeID: "myBadge", image: UIImage(named: "noti.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
            let myIconStyle = PoiIconStyle(symbol: UIImage(named: "icon-map-pin"), anchorPoint: CGPoint(x: 0.5, y: 1.2), badges: [myNoti])
            let friendsNoti = PoiBadge(badgeID: "friendsBadge", image: UIImage(named: "noti2.png"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
            let friendsIconStyle = PoiIconStyle(symbol: UIImage(named: "pin_red.png"), anchorPoint: CGPoint(x: 0.0, y: 0.5), badges: [friendsNoti])
            
            let myPoiStyle = PoiStyle(styleID: "myPoiStyle", styles: [
                PerLevelPoiStyle(iconStyle: myIconStyle, level: 12)
            ])
            let friendsPoiStyle = PoiStyle(styleID: "friendsPoiStyle", styles: [
                PerLevelPoiStyle(iconStyle: myIconStyle, level: 12)
            ])
            
            manager.addPoiStyle(myPoiStyle)
            manager.addPoiStyle(friendsPoiStyle)
        }
        
        func createPois() {
            guard let view = controller?.getView(mapViewName) as? KakaoMap else {
                print("view is nil in createPois")
                return
            }
            let manager = view.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            
            // 내 위치 POI 생성
            let myPoiOption = PoiOptions(styleID: "myPoiStyle")
            myPoiOption.rank = 0
            
            if let myLocation {
                let myPoi = layer?.addPoi(
                    option: myPoiOption,
                    at: MapPoint(longitude: myLocation.x, latitude: myLocation.y)
                )
                myPoi?.show()
            }
            
            // 친구들 위치 POI 생성
            let friendPoiOption = PoiOptions(styleID: "friendsPoiStyle")
            friendPoiOption.rank = 1
            
            for friendLocation in friendsLocation {
                let friendPoi = layer?.addPoi(
                    option: friendPoiOption,
                    at: MapPoint(longitude: friendLocation.x, latitude: friendLocation.y)
                )
                friendPoi?.show()
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

            // 기존 POI 삭제
            let manager = view.getLabelManager()
            if let layer = manager.getLabelLayer(layerID: "PoiLayer") {
                layer.clearAllItems() // TODO: 맞는 메서드인지 확인 필요
            }
            
            // 새로운 POI 생성
            createPois()
            
            // 카메라 이동: 내 위치 중심
            let target = MapPoint(longitude: myNewLocation.x, latitude: myNewLocation.y)
            let cameraUpdate = CameraUpdate.make(
                target: target,
                zoomLevel: 15, mapView: view
            )
            view.moveCamera(cameraUpdate)
            print("MapPinView camera updated! x: \(myNewLocation.x), y: \(myNewLocation.y)")
        }
    }
}

#Preview {
    MapPinView(myLocation: .constant(LongLat(x: 127.0388462, y: 37.495418)), friendsLocation: .constant([LongLat(x: 127.0388461, y: 37.495418), LongLat(x: 127.0388461, y: 37.495417)])) // x: 126.88958060554663, y: 37.50910419634123
}
