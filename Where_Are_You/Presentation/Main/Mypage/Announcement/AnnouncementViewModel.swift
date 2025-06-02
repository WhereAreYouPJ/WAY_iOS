//
//  AnnouncementViewModel.swift
//  Where_Are_You
//
//  Created by 오정석 on 29/5/2025.
//

import Foundation

class AnnouncementViewModel {
    var announcement: [Announcement] = []
    var onGetAnnouncement: (([Announcement]) -> Void)?
    
    func fetchAnnouncement() {
        let data = [Announcement(title: "온마이웨이가 전하는 \n온.마.웨 새출발 가이드", date: "2024.12.03", image: "announcementImage")]
        self.announcement = data
        self.onGetAnnouncement?(data)
    }
}
