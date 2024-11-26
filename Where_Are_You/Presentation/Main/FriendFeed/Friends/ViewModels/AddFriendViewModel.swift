//
//  AddFriendViewModel.swift
//  Where_Are_You
//
//  Created by juhee on 26.11.24.
//

import Foundation

class AddFriendViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var friend: Friend?
}
