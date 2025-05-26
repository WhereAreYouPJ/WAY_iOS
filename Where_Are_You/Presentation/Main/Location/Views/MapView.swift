////
////  SearchPlaceView.swift
////  Where_Are_You
////
////  Created by juhee on 06.09.24.
////
//
//import SwiftUI
//import KakaoMapsSDK
//
//struct MapView: View {
//    @State var draw: Bool = false // 뷰의 appear 상태를 전달하기 위한 변수.
//    @Binding var location: Location
//    
//    var body: some View {
//        KakaoMapView(draw: $draw, location: $location)
//            .onAppear(perform: {
//                self.draw = true
//            })
//            .onDisappear(perform: { self.draw = false })
//            .ignoresSafeArea()
//    }
//}
//
//struct KakaoMapView: UIViewRepresentable {
//    @Binding var draw: Bool
//    @Binding var location: Location
//    
//    /// UIView를 상속한 KMViewContainer를 생성한다.
//    /// 뷰 생성과 함께 KMControllerDelegate를 구현한 Coordinator를 생성하고, 엔진을 생성 및 초기화한다.
//    func makeUIView(context: Self.Context) -> KMViewContainer {
//        let view: KMViewContainer = KMViewContainer()
//        view.sizeToFit()
//        context.coordinator.createController(view)
//        return view
//    }
//    
//    /// Updates the presented `UIView` (and coordinator) to the latest configuration.
//    /// draw가 true로 설정되면 엔진을 시작하고 렌더링을 시작한다.
//    /// draw가 false로 설정되면 렌더링을 멈추고 엔진을 stop한다.
//    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
//        if draw {
//            DispatchQueue.main.asyncAfter(deadline: .now()) {
//                guard let controller = context.coordinator.controller else {
//                    print("Controller is nil in updateUIView")
//                    return
//                }
//                
//                if !controller.isEnginePrepared {
//                    controller.prepareEngine()
//                }
//                
//                if !controller.isEngineActive {
//                    controller.activateEngine()
//                }
//            }
//        } else {
//            context.coordinator.controller?.resetEngine()
//        }
//    }
//    
//    /// Coordinator 생성
//    func makeCoordinator() -> KakaoMapCoordinator {
//        return KakaoMapCoordinator(location: location)
//    }
//    
//    /// Cleans up the presented `UIView` (and coordinator) in anticipation of their removal.
//    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
//        
//    }
//    
//    /// Coordinator 구현. KMControllerDelegate를 adopt한다.
//    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
//        var controller: KMController?
//        var container: KMViewContainer?
//        var location: Location?
//        var first: Bool = true
//        
//        init(location: Location?) {
//            self.location = location
//            super.init()
//        }
//        
//        // KMController 객체 생성 및 event delegate 지정
//        func createController(_ view: KMViewContainer) {
//            container = view
//            controller = KMController(viewContainer: view)
//            controller?.delegate = self
//        }
//        
//        // 엔진 생성 및 초기화 이후, 렌더링 준비가 완료되면 아래 addViews를 호출한다.
//        // 원하는 뷰를 생성한다.
//        func addViews() {
//            let defaultPosition: MapPoint
//            if let location {
//                defaultPosition = MapPoint(longitude: location.x, latitude: location.y)
//            } else {
//                defaultPosition = MapPoint(longitude: 126.978365, latitude: 37.566691)
//            }
//            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
//            
//            guard let controller else {
//                print("Controller is nil in addViews")
//                return
//            }
//            
//            controller.addView(mapviewInfo)
//        }
//        
//        // addView 성공 이벤트 delegate. 추가적으로 수행할 작업을 진행한다.
//        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
//            print("addViewSucceeded called for \(viewName), \(viewInfoName)")
//            guard let view = controller?.getView(viewName) else {
//                print("view not found in addViewSucceeded")
//                return
//            }
//            view.viewRect = container?.bounds ?? .zero
//            
//            createLabelLayer()
//            createPoiStyle()
//            createPois()
//        }
//        
//        // addView 실패 이벤트 delegate. 실패에 대한 오류 처리를 진행한다.
//        func addViewFailed(_ viewName: String, viewInfoName: String) {
//            print("Failed to add view")
//        }
//        
//        func authenticationSucceeded() {
//            print("auth succeed!!")
//            if let controller = controller,
//               !controller.isEngineActive {
//                controller.activateEngine()
//            }
//        }
//        
//        func authenticationFailed(_ errorCode: Int, desc: String) {
//            print("auth failed")
//            print("error code: \(errorCode)")
//            print(desc)
//        }
//        
//        // Poi생성을 위한 LabelLayer 생성
//        func createLabelLayer() {
//            guard let controller else {
//                print("Controller is nil in createLabelLayer")
//                return
//            }
//            
//            guard let view = controller.getView("mapview") as? KakaoMap else {
//                print("view is nil or not KakaoMap type in createLabelLayer")
//                return
//            }
//            let manager = view.getLabelManager()
//            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
//            let _ = manager.addLabelLayer(option: layerOption)
//        }
//        
//        // Poi 표시 스타일 생성
//        func createPoiStyle() {
//            guard let view = controller?.getView("mapview") as? KakaoMap else {
//                print("view is nil in createPoiStyle")
//                return
//            }
//            let manager = view.getLabelManager()
//            
//            let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "icon-map-pin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
//            let iconStyle2 = PoiIconStyle(symbol: UIImage(named: "icon-map-pin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
//            
//            let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
//                PerLevelPoiStyle(iconStyle: iconStyle1, level: 5),
//                PerLevelPoiStyle(iconStyle: iconStyle2, level: 12)
//            ])
//            manager.addPoiStyle(poiStyle)
//        }
//        
//        func createPois() {
//            guard let view = controller?.getView("mapview") as? KakaoMap else {
//                print("view is nil in createPois")
//                return
//            }
//            let manager = view.getLabelManager()
//            let layer = manager.getLabelLayer(layerID: "PoiLayer")
//            
//            let poiOption = PoiOptions(styleID: "PerLevelStyle")
//            poiOption.rank = 0
//            
//            let poi1: Poi?
//            if let location {
//                poi1 = layer?.addPoi(
//                    option: poiOption,
//                    at: MapPoint(longitude: location.x, latitude: location.y)
//                )
//                print("location on")
//            } else {
//                poi1 = layer?.addPoi(option: poiOption, at: MapPoint(longitude: 126.978365, latitude: 37.566691))
//                print("default location")
//            }
//            
//            guard let poi1 else {
//                print("Failed to create POI")
//                return
//            }
//            
//            poi1.show()
//        }
//        
//        // KMViewContainer 리사이징 될 때 호출.
//        func containerDidResized(_ size: CGSize) {
//            guard let mapView = controller?.getView("mapview") as? KakaoMap else {
//                print("mapView not found in containerDidResized")
//                return
//            }
//            mapView.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
//            if first {
//                let cameraUpdate = CameraUpdate.make(
//                    target: MapPoint(longitude: 126.978365, latitude: 37.566691),
//                    mapView: mapView
//                )
//                mapView.moveCamera(cameraUpdate)
//                first = false
//            }
//        }
//    }
//}
//
//#Preview {
//    MapView(location: .constant(Location(sequence: 0, location: "현대백화점 디큐브시티점", streetName: "서울 구로구 경인로 662", x: 126.88958060554663, y: 37.50910419634123)))
//}
