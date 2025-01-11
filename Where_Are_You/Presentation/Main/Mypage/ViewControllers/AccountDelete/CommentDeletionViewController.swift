//
//  CommentDeletionViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 11/1/2025.
//

import UIKit

class CommentDeletionViewController: UIViewController {
    // MARK: - Properties
    private let commentDeletionView = CommentAccountDeletionView()
    private var viewModel: DeleteMemberViewModel!
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = commentDeletionView
        setupActions()
    }
    
    // MARK: - Helpers
    private func setupActions() {
        
    }
    
    // MARK: - Selectors

}
