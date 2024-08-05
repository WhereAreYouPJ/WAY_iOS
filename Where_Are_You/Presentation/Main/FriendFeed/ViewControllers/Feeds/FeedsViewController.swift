//
//  FeedsViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 30/7/2024.
//

import UIKit
import SnapKit

class FeedsViewController: UIViewController {
    
    private let friendsListView = FriendsListView()
    
    override func loadView() {
        view = friendsListView
    }
    
}
