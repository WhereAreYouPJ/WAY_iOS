//
//  TermsWebViewController.swift
//  Where_Are_You
//
//  Created by 오정석 on 23/4/2025.
//

import UIKit
import WebKit

class TermsWebViewController: UIViewController {
    // MARK: - Properties
    private var webView: WKWebView!
    private let titleText: String
    private let urlString: String
    
    // MARK: - Initializer
    init(title: String, urlString: String) {
        self.titleText = title
        self.urlString = urlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupNavigationBar()
        setupWebView()
        loadURL()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = titleText
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.down"),
            style: .plain,
            target: self,
            action: #selector(dismissView)
        )
    }
    
    private func setupWebView() {
        webView = WKWebView()
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func loadURL() {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    // MARK: - Actions
    @objc private func dismissView() {
        dismiss(animated: true)
    }
}
