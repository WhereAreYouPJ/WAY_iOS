//
//  SearchPlaceView.swift
//  Where_Are_You
//
//  Created by juhee on 07.08.24.
//

import SwiftUI

// Model
struct Animal: Identifiable {
    var id = UUID()
    var name: String
}

struct SearchPlaceView: View {
    let animals: [Animal] = [
        .init(name: "dog"),
        .init(name: "cat"),
        .init(name: "cow"),
        .init(name: "bird"),
        .init(name: "pig"),
        .init(name: "monkey"),
        .init(name: "snake")
    ]
    
    var filteredAnimals: [Animal] {
        if searchText.isEmpty {
            return animals
        } else {
            return animals.filter { $0.name.contains(searchText.lowercased())
            }
        }
    }
    
    var searchSuggestions: [Animal] {
        if searchText.isEmpty {
            return []
        } else {
            return animals.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            List(filteredAnimals) { animal in
                Text(animal.name)
                    .onTapGesture {
                        // TODO: 작성
                    }
            }
        }
        .searchable(text: $searchText, prompt: "Search animals") {
            ForEach(searchSuggestions) { suggestion in
                Text(suggestion.name)
                    .searchCompletion(suggestion.name)
            }
        }
    }
    
}

#Preview {
    SearchPlaceView()
}
