//
//  SearchPlaceView.swift
//  Where_Are_You
//
//  Created by juhee on 06.09.24.
//

import SwiftUI

struct SearchLocationView: View {
    @StateObject private var viewModel = SearchLocationViewModel()
    @Binding var selectedLocation: Location
    @Binding var path: NavigationPath
    @Environment(\.presentationMode) var presentationMode
    
    @State var showRecentSearch = true
    
    var body: some View {
        VStack {
            TextField("검색", text: $viewModel.searchText)
                .autocorrectionDisabled()
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
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: {
                                viewModel.searchText = ""
                            }, label: {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            })
                        }
                    }
                )
                .padding()
            
            if viewModel.searchText.isEmpty {
                HStack {
                    Text("최근장소")
                    Spacer()
                    Button("전체삭제") {
                        viewModel.clearRecentSearches()
                    }
                    .foregroundStyle(Color(.color102))
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 12)))
                }
                .padding(.horizontal, 25)
                .padding(.bottom, 6)
                
                List(viewModel.recentSearches) { location in
                    locationRow(location: location)
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                }
            } else {
                List(viewModel.searchResults) { location in
                    locationRow(location: location)
                }
                .listStyle(PlainListStyle())
                
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .navigationTitle("장소 검색")
        .navigationBarTitleDisplayMode(.inline)
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: 16))
        .foregroundStyle(Color(.color34))
        .onChange(of: viewModel.searchText) { _, _ in
            showRecentSearch = (viewModel.searchText == "")
        }
    }
    
    private func locationRow(location: Location) -> some View {
        ZStack(alignment: .leading) {
            HStack {
                VStack {
                    Image("icon-place2")
                        .padding(2)
                    Spacer()
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(location.location)
                            .padding(2)
                    }
                    Text(location.streetName)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 14)))
                        .foregroundStyle(Color(.color153))
                }
                Spacer()
                if showRecentSearch {
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
            path.append(Route.confirmLocation(location))
            print("위치: \(location.location) / \(location.streetName) / \(location.x) / \(location.y)")
        }
    }
}

#Preview {
    SearchLocationView(selectedLocation: .constant(Location(sequence: 0, location: "", streetName: "", x: 0, y: 0)), path: .constant(NavigationPath()))
}
