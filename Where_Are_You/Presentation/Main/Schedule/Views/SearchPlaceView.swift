import SwiftUI
import MapKit

struct SearchPlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var place: Place?
    @Binding var path: NavigationPath
    
    @State private var searchText = ""
    
    let places: [Place] = [
        .init(location: "서울대입구", streetName: "서울 종로구 세종대로 171", x: 37.4808, y: 126.9526),
        .init(location: "여의도공원", streetName: "서울 영등포구 여의공원로 68", x: 37.5268, y: 126.9244),
        .init(location: "올림픽체조경기장", streetName: "서울 종로구 세종대로 173", x: 37.5221, y: 127.1259),
        .init(location: "재즈바", streetName: "서울 종로구 세종대로 174", x: 37.5665, y: 126.9780),
        .init(location: "신도림", streetName: "서울 종로구 세종대로 175", x: 37.5088, y: 126.8912),
        .init(location: "망원한강공원", streetName: "서울 종로구 세종대로 176", x: 37.5545, y: 126.8964),
        .init(location: "부천시청", streetName: "서울 종로구 세종대로 177", x: 37.5037, y: 126.7661)
    ]
    
    var filteredPlaces: [Place] {
        if searchText.isEmpty {
            return places
        } else {
            return places.filter { $0.location.lowercased().contains(searchText.lowercased()) }
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
                                Text(place.location)
                                    .padding(2)
                            }
                            Text(place.streetName)
                                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 14)))
                                .foregroundStyle(Color(.color153))
                        }
                        Spacer()
                        Image("icon-delete")
                            .opacity(0.3)
                    }
                    
                    NavigationLink(destination: PlaceMapView(place: $place, path: $path)) {
                        Text(place.location)
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
    SearchPlaceView(place: .constant(Place(location: "서울대입구", streetName: "서울 종로구 세종대로 171", x: 37.4808, y: 126.9526)), path: .constant(NavigationPath()))
}
