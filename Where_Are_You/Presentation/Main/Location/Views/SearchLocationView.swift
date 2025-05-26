//
//  SearchPlaceView.swift
//  Where_Are_You
//
//  Created by juhee on 06.09.24.
//

import SwiftUI

struct SearchLocationView: View {
    @StateObject private var viewModel = SearchLocationViewModel()
    
    @Binding var selectedLocation: Location?
    @Binding var showConfirmLocation: Bool
    @Binding var selectedLocationForConfirm: Location?
    
    @State var showRecentSearch = true
    @State private var showConfirmFromSearch = false
    
    var dismissAction: () -> Void
    
    // dummy
//    var recentSearches = [
//        Location(sequence: 1, location: "신도림역", streetName: "신도림역 1호선", x: 0, y: 0),
//        Location(sequence: 1, location: "서울역", streetName: "서울역 1호선", x: 0, y: 0),
//        Location(sequence: 1, location: "망원한강공원", streetName: "망원한강공원", x: 0, y: 0),
//    ]
    
    var body: some View {
        VStack {
            HStack {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                .padding(.leading, LayoutAdapter.shared.scale(value: 16))
                .padding(.trailing, LayoutAdapter.shared.scale(value: 4))
                
                TextField("장소 검색", text: $viewModel.searchText)
                    .autocorrectionDisabled()
                    .padding(LayoutAdapter.shared.scale(value: 7))
                    .padding(.horizontal, LayoutAdapter.shared.scale(value: 25))
                    .background(Color(.systemGray6))
                    .cornerRadius(LayoutAdapter.shared.scale(value: 8))
                    .overlay(
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .padding(.leading, LayoutAdapter.shared.scale(value: 8))
                            
                            if !viewModel.searchText.isEmpty {
                                Button(action: {
                                    viewModel.searchText = ""
                                }, label: {
                                    Image(systemName: "multiply.circle.fill")
                                        .foregroundColor(.gray)
                                        .padding(.trailing, LayoutAdapter.shared.scale(value: 8))
                                })
                            }
                        }
                    )
                    .padding(.trailing, LayoutAdapter.shared.scale(value: 16))
            } // HStack
            .padding(.top, LayoutAdapter.shared.scale(value: 10))
            
            if viewModel.searchText.isEmpty {
                HStack {
                    Text("최근장소")
                    
                    Spacer()
                    
                    Button("전체삭제") {
                        viewModel.clearRecentSearches()
                    }
                    .bodyP4Style(color: .black66)
                }
                .padding(.top, LayoutAdapter.shared.scale(value: 20))
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 24))
                
//                List(recentSearches) { location in
                List(viewModel.recentSearches) { location in
                    locationRow(location: location)
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                }
            } else {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.searchResults.isEmpty {
                    noResultsView()
                        .padding(.top, LayoutAdapter.shared.scale(value: 70))
                } else {
                    List(viewModel.searchResults) { location in
                        locationRow(location: location)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, LayoutAdapter.shared.scale(value: 16))
                }
            }
        }
        .navigationTitle("장소 검색")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showConfirmFromSearch) {
            if let location = selectedLocationForConfirm {
                ConfirmLocationView(
                    location: location,
                    presentationMode: .fromSearch, // SearchLocationView에서 온 경우
                    dismissAction: { // 확인 버튼을 눌렀을 때 - CreateScheduleView로 돌아가기
                        showConfirmFromSearch = false
                        dismissAction()
                    },
                    backToSearchAction: { // 뒤로가기 버튼을 눌렀을 때 - SearchLocationView로 돌아가기
                        showConfirmFromSearch = false
                    }
                )
            }
        }
        .foregroundStyle(Color(.black22))
        .onChange(of: viewModel.searchText) { _, _ in
            showRecentSearch = (viewModel.searchText == "")
        }
        .bodyP3Style(color: .black22)
    }
    
    private func locationRow(location: Location) -> some View {
        ZStack(alignment: .leading) {
            HStack {
                VStack {
                    Image("icon-place2")
                        .padding(LayoutAdapter.shared.scale(value: 2))
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: LayoutAdapter.shared.scale(value: 5)) {
                    HighlightedText(
                        text: location.location,
                        highlightText: viewModel.searchText,
                        highlightColor: .brandDark
                    )
                    
                    HighlightedText(
                        text: location.streetName,
                        highlightText: viewModel.searchText,
                        highlightColor: .brandDark
                    )
                    .bodyP4Style(color: .black66)
                    .foregroundStyle(Color(.color153))
                }
                
                Spacer()
                
                if showRecentSearch { // 검색 결과 삭제 버튼
                    Image("icon-delete")
                        .opacity(0.3)
                        .onTapGesture {
                            viewModel.deleteRecentSearch(location: location)
                        }
                }
            }
        }
        .onTapGesture {
            selectedLocation = location
            viewModel.addToRecentSearches(location)
            
            selectedLocationForConfirm = location
            showConfirmFromSearch = true
            
            print("위치: \(location.location) / \(location.streetName) / \(location.x) / \(location.y)")
        }
    }
    
    private func noResultsView() -> some View {
        VStack(spacing: 0) {
            Image("icon-notice")
                .padding(.bottom, LayoutAdapter.shared.scale(value: 10))
            
            Text("검색결과가 없습니다.")
                .bodyP2Style(color: .blackD4)
            
            Group {
                Text("검색어에 해당하는 위치가 존재하지 않습니다.")
                Text("다시 한번 확인해 주세요.")
            }
            .bodyP4Style(color: .blackD4)
            .padding(.top, LayoutAdapter.shared.scale(value: 6))
            
            Spacer()
        }
    }
}

#Preview {
    SearchLocationView(
        selectedLocation: .constant(nil),
        showConfirmLocation: .constant(false),
        selectedLocationForConfirm: .constant(nil),
        dismissAction: {}
    )
}
