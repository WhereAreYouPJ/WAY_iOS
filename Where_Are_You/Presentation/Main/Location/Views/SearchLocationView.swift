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
    
    var dismissAction: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Button(action: dismissAction) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                }
                .padding(.leading, LayoutAdapter.shared.scale(value: 16))
                
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
            }
            .padding(.vertical, LayoutAdapter.shared.scale(value: 10))
            
            if viewModel.searchText.isEmpty {
                HStack {
                    Text("최근장소")
                    Spacer()
                    Button("전체삭제") {
                        viewModel.clearRecentSearches()
                    }
                    .foregroundStyle(Color(.black66))
                    .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 12))))
                }
                .padding(.horizontal, LayoutAdapter.shared.scale(value: 25))
                .padding(.bottom, LayoutAdapter.shared.scale(value: 10))
                
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
        .environment(\.font, .pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 16)))
        .foregroundStyle(Color(.black22))
        .onChange(of: viewModel.searchText) { _, _ in
            showRecentSearch = (viewModel.searchText == "")
        }
    }
    
    private func locationRow(location: Location) -> some View {
        ZStack(alignment: .leading) {
            HStack {
                VStack {
                    Image("icon-place2")
                        .padding(LayoutAdapter.shared.scale(value: 2))
                    Spacer()
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(location.location)
                            .padding(LayoutAdapter.shared.scale(value: 2))
                    }
                    Text(location.streetName)
                        .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: LayoutAdapter.shared.scale(value: 14))))
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
            
            selectedLocationForConfirm = location
            dismissAction() // SearchLocation 화면을 닫고
            showConfirmLocation = true // ConfirmLocation 화면을 표시
            
            print("위치: \(location.location) / \(location.streetName) / \(location.x) / \(location.y)")
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
