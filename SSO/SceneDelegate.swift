import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        if url.scheme == "edgesso" {
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
               let queryItems = components.queryItems {
                for item in queryItems {
                    if item.name == "code", let authorizationCode = item.value {
                        // Handle the authorization code, e.g., exchange it for tokens
                        print("Authorization Code: \(authorizationCode)")
                        // Mock the token exchange
                        exchangeAuthorizationCode(for: authorizationCode)
                    }
                }
            }
        }
    }

    func exchangeAuthorizationCode(for code: String) {
        let config = URLSessionConfiguration.default
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        
        MockURLProtocol.requestHandler = { request in
            let data = """
            {
                "access_token": "mock_access_token",
                "refresh_token": "mock_refresh_token",
                "expires_in": 3600
            }
            """.data(using: .utf8)!
            
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, data)
        }
        
        let tokenUrlString = "https://your-sso-provider.com/token"
        let clientId = "YOUR_CLIENT_ID"
        let clientSecret = "YOUR_CLIENT_SECRET"
        let redirectUri = "edgesso://callback"

        var request = URLRequest(url: URL(string: tokenUrlString)!)
        request.httpMethod = "POST"
        let bodyString = "grant_type=authorization_code&" +
                         "code=\(code)&" +
                         "redirect_uri=\(redirectUri)&" +
                         "client_id=\(clientId)&" +
                         "client_secret=\(clientSecret)"
        request.httpBody = bodyString.data(using: .utf8)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("No data received")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Mock Response JSON: \(json)")
                }
            } catch {
                print("JSON parsing error: \(error)")
            }
        }
        task.resume()
    }
}

