//
//  AnnouncementViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 28/5/2025.
//

import UIKit

class AnnouncementViewController: UIViewController {
    let announcementView = AnnouncmentCommonView()
        
    var announcementData: Announcement
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = announcementView
        setupActions()
    }
    
    init(announcementData: Announcement) {
        self.announcementData = announcementData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        configureNavigationBar(title: "공지사항", backButtonAction: #selector(backButtonTapped))
        announcementView.configure(with: announcementData.title, date: announcementData.date, image: announcementData.image)
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
}
