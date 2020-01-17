//
//  ChopraLoginViewController.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

import Foundation
import UIKit
import WebKit
import CryptoSwift
import GoogleSignIn
import SwiftyJSON

public enum ChopraLoginType {
    case google
    case facebook
    case email
}

public class ChopraLoginViewController: UIViewController {
    
    var baseUrl: String?
    var apiUrl: String?
    var apiKey: String?
    var clientKey: String?
    var platform: String?
    var namespace: String?
    var clientSecret: String?
    
    var socialToken: String?
    var socialId: String?
    var loginType: ChopraLoginType?
    
    var completionHandler: ((String?, String?) -> Void)?
    
    var webView: WKWebView?
    var closeButton: UIImageView?
    var activityIndicator: UIActivityIndicatorView?
    var contentView: UIView?
    
    var isRegistration: Bool = false
    
    public func setLoginBaseUrl(_ baseUrl: String?, apiUrl: String?, apiKey: String?, clientKey: String?, platform: String?, nameSpace: String?, clientSecret: String?) {
        self.baseUrl = baseUrl
        self.apiUrl = apiUrl
        self.apiKey = apiKey
        self.clientKey = clientKey
        self.platform = platform
        self.namespace = nameSpace
        self.clientSecret = clientSecret
    }
    
    public func showSocialLoginView(from rootViewController: UIViewController, socialToken: String, socialId: String, socialType: ChopraLoginType, withHandler completionHandler: @escaping ((String?, String?) -> Void)) {
        
        self.socialToken = socialToken
        self.socialId = socialId
        self.loginType = socialType
        
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        rootViewController.present(self, animated: true, completion: nil)
        
        self.completionHandler = completionHandler
    }
    
    public func showEmailLoginView(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((String?, String?) -> Void)) {
        
        self.loginType = ChopraLoginType.email
        
        self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        rootViewController.present(self, animated: true, completion: nil)
        
        self.completionHandler = completionHandler
    }
    
    public func showRegistrationView(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((String?, String?) -> Void)) {
        
        self.isRegistration = true
        
        self.showEmailLoginView(from: rootViewController, withHandler: completionHandler)
    }
    
    public func loginWithEmail(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((String?, String?) -> Void)) {
        
        self.showEmailLoginView(from: rootViewController, withHandler: completionHandler)
    }
    
    public func loginWithFacebook(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((String?, String?) -> Void)) {
        
        FacebookHelper.shared.login(from: rootViewController) { (success, userId, userToken) in
            if success, let userToken = userToken, let userId = userId {
                self.showSocialLoginView(from: rootViewController, socialToken: userToken, socialId: userId, socialType: ChopraLoginType.facebook, withHandler: completionHandler)
            } else {
                completionHandler(nil, nil)
            }
        }
    }

    public func loginWithGoogle(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((String?, String?) -> Void)) {
        
        GoogleHelper.shared.login(from: rootViewController) { (success, userId, userToken) in
            if success, let userToken = userToken, let userId = userId {
                self.showSocialLoginView(from: rootViewController, socialToken: userToken, socialId: userId, socialType: ChopraLoginType.google, withHandler: completionHandler)
            } else {
                completionHandler(nil, nil)
            }
        }
    }
    
    public func getChopraAccount(_ ssoToken: String?, completionHandler: @escaping ((ChopraAccount?) -> Void)) {
        guard let ssoToken = ssoToken else {
            completionHandler(nil)
            return
        }
        
        sendJSONRequest(ssoToken, completionHandler: completionHandler)
    }
    
    public func sendJSONRequest(_ userToken: String?, completionHandler: @escaping ((ChopraAccount?) -> Void)) {
        if let userToken = userToken, let apiUrl = apiUrl, let url = URL(string: apiUrl + "/auth") {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue(apiKey, forHTTPHeaderField: "X-SSO-ApiKey")
            request.setValue(clientKey, forHTTPHeaderField: "X-SSO-ClientKey")
            request.setValue(String(format: "Bearer %@", userToken), forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    let requestReply = String(data: data, encoding: .utf8)
                    print(String(format: "Request reply data: %@", requestReply ?? "unknown"))
                    
                    if let jsonDictionary = ((try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())) as? [String : Any?]) ?? nil {
                        let json = JSON(jsonDictionary)
                        if !json["error"].stringValue.isEmpty {
                            completionHandler(nil)
                        } else {
                            let chopraAccount = ChopraAccount(json: json)
                            completionHandler(chopraAccount)
                        }
                    } else {
                        print("\nCannot convert data to a dictionary\n")
                        completionHandler(nil)
                    }
                }
                print(String(format: "Request reply: %@", response ?? "unknown"))
            }).resume()
        }
    }
    
    public func logout(_ ssoToken: String?) {
        if let ssoToken = ssoToken, let apiUrl = apiUrl, let url = URL(string: apiUrl + "/auth") {
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            request.setValue(apiKey, forHTTPHeaderField: "X-SSO-ApiKey")
            request.setValue(clientKey, forHTTPHeaderField: "X-SSO-ClientKey")
            request.setValue(String(format: "Bearer %@", ssoToken), forHTTPHeaderField: "Authorization")
            
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    let requestReply = String(data: data, encoding: .utf8)
                    print(String(format: "Logout response data: %@", requestReply ?? "unknown"))
                }
                print(String(format: "Logout response: %@", response ?? "unknown"))
            }).resume()
        }
    }
    
    func hasNotch() -> Bool {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
            case 1334:
                print("iPhone 6/6S/7/8")
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
            case 2436:
                print("iPhone X, XS")
                return true
            case 2688:
                print("iPhone XS Max")
                return true
            case 1792:
                print("iPhone XR")
                return true
            default:
                print("Unknown")
            }
        }
        return false
    }
    
    // MARK: - Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        let topConstaint: CGFloat = hasNotch() ? 55 : 35
        let bottomConstaint: CGFloat = hasNotch() ? 35 : 20

        contentView = UIView(frame: CGRect(x: view.frame.origin.x + 15, y: view.frame.origin.y + topConstaint, width: view.frame.width - 30, height: view.frame.height - topConstaint - bottomConstaint))
        contentView?.backgroundColor = .white
        view.addSubview(contentView!)
        
        webView = WKWebView(frame: CGRect(x: view.frame.origin.x + 15, y: view.frame.origin.y + topConstaint, width: view.frame.width - 30, height: view.frame.height - topConstaint - bottomConstaint), configuration: WKWebViewConfiguration())
        webView?.scrollView.bounces = false
        view.addSubview(webView!)
        
        closeButton = UIImageView(image: loadImageFromResourceBundle(named: "icon_default.png") , highlightedImage: loadImageFromResourceBundle(named: "icon_pressed.png"))
        closeButton?.frame = CGRect(x: view.frame.origin.x + 5, y: view.frame.origin.y + topConstaint - 15, width: 30, height: 30)
        closeButton?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonTouch)))
        closeButton?.isMultipleTouchEnabled = true
        closeButton?.isUserInteractionEnabled = true
        view.addSubview(closeButton!)
        
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator?.activityIndicatorViewStyle = .gray
        activityIndicator?.hidesWhenStopped = true
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
        
        webView?.isHidden = true
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        URLCache.shared.removeAllCachedResponses()
        super.viewWillAppear(animated)
        
        guard var url = baseUrl, !url.isEmpty else {
            return
        }
        
        if let socialToken = socialToken, !socialToken.isEmpty {
            url += "/social/tokenauth"
        } else if !isRegistration {
            url += "/tokenauth"
        } else {
            url += "/tokenauth/registration"
            isRegistration = false
        }
        
        guard let clientKey = clientKey, let platform = platform, let namespace = namespace else {
            return
        }
        url = String(format: "%@?client_key=%@&platform_type=%@&namespace=%@", url, clientKey, platform, namespace)
        
        if let socialId = socialId, let socialToken = socialToken, !socialToken.isEmpty, let encryptedStuff = encryptSocialToken(socialToken) {
            url = String(format: "%@&social_id=%@&social_token=%@&social_type=%@", url, socialId, encryptedStuff, loginType == .facebook ? "facebook" : "google")
        }
        
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView?.uiDelegate = self
            webView?.navigationDelegate = self
            webView?.load(request)
        } else {
            // TODO
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.backgroundColor = UIColor.clear.withAlphaComponent(0.2)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if var oldFrame = activityIndicator?.frame {
            oldFrame.origin.x = (view.frame.size.width - 50.0) / 2.0
            oldFrame.origin.y = (view.frame.size.height - 50.0) / 2.0
            
            activityIndicator?.frame = oldFrame
        }
    }
    
    // MARK: - Functions
    
    @objc func closeButtonTouch(_ sender: UIGestureRecognizer) {
        completionHandler?(nil, nil)
        completionHandler = nil
        
        closeButton?.image = loadImageFromResourceBundle(named: "icon_default.png")
        webView?.stopLoading()
        webView?.uiDelegate = nil
        webView?.navigationDelegate = nil
        
        socialToken = nil;
        
        dismiss(animated: true, completion: nil)
    }

    private func encryptSocialToken(_ token: String) -> String? {
        let serializer = RTSerializer()
        let serializedString = serializer.serialize(token, isString: "")
        
        let ivString = randomString(withLength: 16)
        let ivData = Data(ivString.utf8)
        let base64EncodedIv = ivData.base64EncodedString()
        
        guard let clientSecret = clientSecret,
            let message = serializedString.data(using: .utf8), let encryptedTokenData = try? (try? AES(key: Array(clientSecret.utf8), blockMode: CBC(iv: Array(ivString.utf8))))?.encrypt(Array(message)),
            let encryptedTokenString = encryptedTokenData?.toBase64() else {
                
            return nil
        }
        
        let base64EncodedIvAndValue = base64EncodedIv + encryptedTokenString
        let macString = getHashEncription(key: clientSecret, data: base64EncodedIvAndValue)
        let dictionary = [
            "iv": base64EncodedIv,
            "value": encryptedTokenString,
            "mac": macString
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions()) else {
            return nil
        }
        
        let jsonString = String(data: jsonData, encoding: .utf8)
        let stringData = jsonString?.data(using: .utf8)
        let base64Encoded = stringData?.base64EncodedString()
        
        return base64Encoded
    }
    
    private func getHashEncription(key: String, data: String) -> String? {
        guard var cKey: Array<Int8> = key.cString(using: .ascii),
            var cData: Array<Int8> = data.cString(using: .ascii)
        else {
                return nil
        }
        
        // Pop \0 character, because it messes up the encoding
        let _ = cKey.popLast()
        let _ = cData.popLast()
        
        var ucKey: Array<UInt8> = []
        var ucData: Array<UInt8> = []
        
        for char in cKey {
            ucKey.append(UInt8(bitPattern: char))
        }
        for char in cData {
            ucData.append(UInt8(bitPattern: char))
        }
        
        let hmac: HMAC = HMAC(key: ucKey, variant: .sha256)
        let cHmac = (try? hmac.authenticate(ucData)) ?? []
        
        var output = ""
//        for ind in 0..<SHA2.Variant.sha256.digestLength {
        for cChar in cHmac {
            output += String(format: "%02x", cChar)
        }
        
        return output
    }
    
    private func randomString(withLength length: UInt32) -> String {
        let letters: [Character] = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        var randomString = ""
        for _ in 0..<length {
            randomString += String(letters[Int(arc4random_uniform(length))])
        }
        
        return randomString;
    }
    
    private func loadImageFromResourceBundle(named imageName: String) -> UIImage? {
        guard let bundleUrl = Bundle(for: ChopraLoginViewController.self).url(forResource: "ChopraSSO", withExtension: "bundle") else {
            return nil
        }
        
        let bundle = Bundle(url: bundleUrl)
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
}

extension ChopraLoginViewController: URLSessionDelegate {
    
}

//extension ChopraLoginViewController: GIDSignInUIDelegate {
//    
//}

extension ChopraLoginViewController: WKNavigationDelegate, WKUIDelegate {
    
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        webView.isHidden = false
        activityIndicator?.stopAnimating()
        
        guard let currentUrl = webView.url?.query  else {
            return
        }
//        NSString *currentURL = webView.request.URL.query;
        
        if currentUrl.contains("sso_code"), completionHandler != nil {
            let url = currentUrl.replacingOccurrences(of: "#", with: "&")
            var params: [String: String?] = [:]
            for param in url.components(separatedBy: "&") {
                let elts = param.components(separatedBy: "=")
                if elts.count >= 2, let key = elts.first {
                    params[key] = elts[1]
                }
            }
            
            guard let ssoCode = params["sso_code"]??.removingPercentEncoding,
                let decodedData = Data(base64Encoded: ssoCode),
                let base64Decoed = String(data: decodedData, encoding: .utf8)?.trimmingCharacters(in: CharacterSet.whitespaces),
                let data = base64Decoed.data(using: .ascii),
                let json = (try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any?]
            else {
                return
            }

            let keyData = clientSecret?.data(using: .utf8)
            guard var decryptedMessage = (json["value"] as? String)?.description.bb_AESDecryptedStringForIV(iv: nil, key: keyData) else {
                return
            }
            decryptedMessage = "a:2:{s:4:" + decryptedMessage
            
            let serializer: RTSerializer = RTSerializer()
            guard let object = serializer.deserialize(decryptedMessage) as? [String: Any?] else {
                return
            }
            var userId: String? = nil
            if let id = object["u_id"] as? Int {
                userId = String(id)
            }
            let userToken = object["api_token"]  as? String
            
            completionHandler?(userId, userToken)
            completionHandler = nil
            
            webView.stopLoading()
            webView.uiDelegate = nil
            webView.navigationDelegate = nil
            dismiss(animated: true, completion: nil)
            socialToken = nil
        }
    }
}

