import SwiftUI
import MapKit

struct SearchPlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var location: String
    @Binding var streetName: String
    @Binding var x: Double
    @Binding var y: Double
    @Binding var path: NavigationPath
    
    @State private var selectedPlace: Place?
    
    let places: [Place] = [
        .init(name: "서울대입구", coordinate: CLLocationCoordinate2D(latitude: 37.4808, longitude: 126.9526), address: "서울 종로구 세종대로 171"),
        .init(name: "여의도공원", coordinate: CLLocationCoordinate2D(latitude: 37.5268, longitude: 126.9244), address: "서울 종로구 세종대로 172"),
        .init(name: "올림픽체조경기장", coordinate: CLLocationCoordinate2D(latitude: 37.5221, longitude: 127.1259), address: "서울 종로구 세종대로 173"),
        .init(name: "재즈바", coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), address: "서울 종로구 세종대로 174"),
        .init(name: "신도림", coordinate: CLLocationCoordinate2D(latitude: 37.5088, longitude: 126.8912), address: "서울 종로구 세종대로 175"),
        .init(name: "망원한강공원", coordinate: CLLocationCoordinate2D(latitude: 37.5545, longitude: 126.8964), address: "서울 종로구 세종대로 176"),
        .init(name: "부천시청", coordinate: CLLocationCoordinate2D(latitude: 37.5037, longitude: 126.7661), address: "서울 종로구 세종대로 177")
    ]
    
    @State private var searchText = ""
    
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return places
        } else {
            return places.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    var body: some View {
        VStack {
            TextField("검색", text: $searchText)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !searchText.isEmpty {
                            Button(action: {
                                self.searchText = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding()
            
            if searchText.isEmpty {
                HStack {
                    Text("최근장소")
                    Spacer()
                    Text("전체삭제")
                        .foregroundStyle(Color(.color102))
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 12)))
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 6)
            }
            
            List(filteredPlaces) { place in
                ZStack(alignment: .leading) {
                    HStack {
                        VStack {
                            Image("icon-place2")
                                .padding(2)
                            Spacer()
                        }
                        VStack(alignment: .leading) {
                            HStack {
                                Text(place.name)
                                    .padding(2)
                            }
                            Text(place.address)
                                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 14)))
                                .foregroundStyle(Color(.color153))
                        }
                        Spacer()
                        Image("icon-delete")
                            .opacity(0.3)
                    }
                    
                    NavigationLink(destination: PlaceMapView(place: place, location: $location, streetName: $streetName, x: $x, y: $y, path: $path)) {
                        Text(place.name)
                    }
                    .opacity(0.0)
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("장소 검색")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        .foregroundStyle(Color(.color34))
    }
}

#Preview {
    SearchPlaceView(location: .constant(""), streetName: .constant(""), x: .constant(0.0), y: .constant(0.0), path: .constant(NavigationPath()))
}
