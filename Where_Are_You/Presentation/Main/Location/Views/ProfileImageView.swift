//
//  ProfileImageView.swift
//  Where_Are_You
//
//  Created by juhee on 18.12.24.
//

import SwiftUI

// 프로필 이미지를 위한 SwiftUI View
struct ProfileImageView: View {
    let image: Image
    
    var body: some View {
        ZStack {
            Image("icon-location-anchor")
                .frame(width: LayoutAdapter.shared.scale(value: 11), height: LayoutAdapter.shared.scale(value: 11))
                .padding(.top, 55)
            Image("icon-location-pin")
                .frame(width: LayoutAdapter.shared.scale(value: 45), height: LayoutAdapter.shared.scale(value: 56))
            
            image
                .resizable()
                .scaledToFill()
                .frame(width: LayoutAdapter.shared.scale(value: 37), height: LayoutAdapter.shared.scale(value: 37))
                .clipShape(Circle())
                .frame(width: LayoutAdapter.shared.scale(value: 10), height: LayoutAdapter.shared.scale(value: 10))
                .padding(.bottom, 10)
        }
    }
}

#Preview {
    ProfileImageView(image: Image("exampleProfileImage"))
}
