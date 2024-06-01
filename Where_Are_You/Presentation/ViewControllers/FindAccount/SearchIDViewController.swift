//
//  SearchIDViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 1/6/2024.
//

import UIKit
import SnapKit

class SearchIDViewController: UIViewController {
    // MARK: - Properties
    
    let searchIDView = SearchIDView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchIDView)
        searchIDView.frame = view.bounds
    }
}
