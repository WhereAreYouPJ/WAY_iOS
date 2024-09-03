//
//  CommonFriensView.swift
//  Where_Are_You
//
//  Created by juhee on 02.09.24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText: String
    let onClear: () -> Void
    
    var body: some View {
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
                        Button(action: onClear) {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundStyle(.gray)
                                .padding(.trailing, 8)
                        }
                    }
                }
            )
            .padding(.horizontal)
    }
}

struct FriendCell: View {
    let friend: Friend
    var showToggle: Bool = false
    var isOn: Binding<Bool>? = nil

    var body: some View {
        HStack {
            Image(friend.profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.14, height: UIScreen.main.bounds.width * 0.14)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Text(friend.name)
                .font(Font(UIFont.pretendard(NotoSans: .regular, fontSize: 17)))
                .foregroundColor(Color(.color34))
                .padding(8)

            Spacer()

            if showToggle, let isOn = isOn {
                Toggle("", isOn: isOn)
                    .toggleStyle(CheckboxToggleStyle())
            }
        }
        .padding(.vertical, 6)
    }
}
