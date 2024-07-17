//
//  ViewController.swift
//  SSO
//
//  Created by Kashif Hussain on 17/07/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = UIButton(type: .system)
        loginButton.setTitle("Login with SSO", for: .normal)
        loginButton.addTarget(self, action: #selector(startAuthentication), for: .touchUpInside)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func startAuthentication() {
            let clientId = "YOUR_CLIENT_ID"
            let redirectUri = "edgesso://callback"
            let responseType = "code"
            let scope = "openid profile email"
            let state = UUID().uuidString

            let authUrlString = "https://httpbin.org/redirect-to?url=\(redirectUri)?code=mock_authorization_code"
            
            if let authUrl = URL(string: authUrlString) {
                let edgeUrl = URL(string: "\(authUrl.absoluteString)")
                if UIApplication.shared.canOpenURL(edgeUrl!) {
                    UIApplication.shared.open(edgeUrl!)
                } else {
                    // Edge is not installed, open in Safari as fallback
                    UIApplication.shared.open(authUrl)
                }
            }
        }
}
