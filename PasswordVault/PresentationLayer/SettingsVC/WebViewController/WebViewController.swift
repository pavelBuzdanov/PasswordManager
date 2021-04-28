//
//  WebViewController.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 27.04.2021.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // MARK: - Properties
    var urlString: String?
    
    // MARK: - Views
    private lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let view = WKWebView(frame: .zero, configuration: webConfiguration)
        view.navigationDelegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 13.0, *) {
            indicator.style = .large
        }
        indicator.color = UIColor.blue
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        return indicator
    }()
    
    private let backButtonButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Close", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(backButtonButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
    }
    
    // MARK: - SetupView
    private func setupView() {
        layoutView()
        view.backgroundColor = UIColor.ViewControllerColor.backgroundColor
        guard let urlString = self.urlString else { return }
        loadURL(urlString: urlString)
    }
    
    // MARK: - Actions
    private func loadURL(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    private func addActivityIndicator() {
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make) in
            make.center.equalTo(view.snp.center)
        }
        activityIndicator.startAnimating()
    }
    
    private func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    @objc private func backButtonButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - LayoutView
    private func layoutView() {
        view.addSubview(webView)
        view.addSubview(backButtonButton)
        
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        backButtonButton.snp.makeConstraints { (make) in
            make.leading.equalTo(view.snp.leading).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}

// MARK: - WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        addActivityIndicator()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideActivityIndicator()
    }
}
