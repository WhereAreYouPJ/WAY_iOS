//
//  MainTabView.swift
//  Where_Are_You
//
//  Created by juhee on 27.10.24.
//

import SwiftUI
import UIKit

// UIKit 뷰 컨트롤러들을 SwiftUI에서 사용하기 위한 래퍼
struct MainHomeViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MainHomeViewController {
        return MainHomeViewController()
    }
    
    func updateUIViewController(_ uiViewController: MainHomeViewController, context: Context) {}
}

struct FriendFeedViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> FriendFeedViewController {
        return FriendFeedViewController()
    }
    
    func updateUIViewController(_ uiViewController: FriendFeedViewController, context: Context) {}
}

struct MyPageViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> MyPageViewController {
        return MyPageViewController()
    }
    
    func updateUIViewController(_ uiViewController: MyPageViewController, context: Context) {}
}

// 메인 탭 뷰
struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationView {
                MainHomeViewControllerWrapper()
            }
            .tabItem {
                Image("icon-home")
                    .renderingMode(.template)
                Text("홈")
            }
            .tag(0)
            
            NavigationView {
                ScheduleView()
            }
            .tabItem {
                Image("icon-schedule")
                    .renderingMode(.template)
                Text("일정")
            }
            .tag(1)
            
            NavigationView {
                FriendFeedViewControllerWrapper()
            }
            .tabItem {
                Image("icon-friends")
                    .renderingMode(.template)
                Text("피드")
            }
            .tag(2)
            
            NavigationView {
                MyPageViewControllerWrapper()
            }
            .tabItem {
                Image("icon-mypage")
                    .renderingMode(.template)
                Text("마이페이지")
            }
            .tag(3)
        }
        .accentColor(Color(.brandColor))  // 선택된 탭 아이템 색상
        .onAppear {
            // 탭바 스타일 설정
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = .white
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // 선택되지 않은 탭 아이템 색상
            UITabBar.appearance().unselectedItemTintColor = .color34
        }
    }
}

#Preview {
    MainTabView()
}
