//
//  SearchPlaceView.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI

struct SearchPlaceView: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search", text: $text)
                    .foregroundColor(.primary)
                
                if !text.isEmpty {
                    Button(action: {
                        self.text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                    }
                } else {
                    EmptyView()
                }
            }
            .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10.0)
        }
        .padding(.horizontal)
        
    }
}

struct SearchView: View {
    let array = [
        "예시", "예시2", "예시3", "예시4", "예시5", "예시6",
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                SearchPlaceView(text: $searchText)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                
                List {
                    ForEach(array.filter{ $0.hasPrefix(searchText) || searchText == "" }, id: \.self) { searchText in
                        Text(searchText)
                    }
                } //리스트의 스타일 수정
                .listStyle(PlainListStyle())
                //화면 터치시 키보드 숨김
                .onTapGesture {
                    hideKeyboard()
                }
            }
        }
    }
}

//캔버스 컨텐츠뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

//화면 터치시 키보드 숨김
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
