//
//  AuthViewController.swift
//  Gallery
//
//  Created by Sonya Fedorova on 30.04.2023.
//

import UIKit
import WebKit
import Combine

final class AuthViewController: UIViewController {
    
    private lazy var webView: WKWebView = WKWebView()
    private lazy var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private let viewModel: AuthViewOutput
    private var requestSubscription: Cancellable?
    
    // MARK: - Life Cycle
    
    init(viewModel: AuthViewOutput) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Authorization".localized()
        view.backgroundColor = .systemBackground
        configureButtons()
        setupWebView()
        setupActivityIndicator()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        requestSubscription?.cancel()
    }
    
    // MARK: - UI Setup
    
    private func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel".localized(), style: .plain, target: self, action: #selector (didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector (didTapRefresh))
    }
    
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        view.addSubview(webView)

        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.isHidden = false
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
    
    // MARK: - Actions

    @objc private func didTapCancel() {
        self.dismiss(animated: true)
    }
    
    @objc private func didTapRefresh() {
        activityIndicator.startAnimating()
        viewModel.reloadRequest()
    }
    
    // MARK: - Combine
    
    private func bindViewModel() {
        requestSubscription = viewModel.requestPublisher?
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { result in
                switch result {
                case .success(let request):
                    self.webView.load(request)
                case .failure(let error):
                    self.activityIndicator.stopAnimating()
                    self.presentAlert(title: "Error".localized(), message: error.localizedDescription)
                }
            })
    }
    
}

// MARK: - WKNavigationDelegate

extension AuthViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
        viewModel.failedWithError(error) { message, okActionHandler in
            self.presentAlert(title: "Error".localized(), message: message, okActionHandler: okActionHandler)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationResponse: WKNavigationResponse,
                 decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        viewModel.decidePolicy(decidePolicyFor: navigationResponse) { result in
            switch result {
            case .success(let policy):
                decisionHandler(policy)
            case .failure(let error):
                decisionHandler(.cancel)
                self.presentAlert(title: "Error".localized(), message: error.localizedDescription) { _ in
                    self.viewModel.reloadRequest()
                }
            }
            
        }
    }
}
