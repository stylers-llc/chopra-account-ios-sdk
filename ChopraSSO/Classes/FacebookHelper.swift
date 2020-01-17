//
//  FacebookHelper.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

import FBSDKLoginKit

class FacebookHelper: SocialHelper {
    
    static var shared: FacebookHelper = FacebookHelper()
    
    var clientId: String?
    
    var loginManager: LoginManager
    
    init() {
        self.loginManager = LoginManager()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ApplicationDelegate.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func login(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((Bool, String?, String?) -> Void)) {
        if let _ = AccessToken.current {
            self.returnUserData(completionHandler: completionHandler)
        } else {
            self.loginManager.logIn(permissions: [], from: rootViewController) { (loginResult, error) in
                if let loginResult = loginResult, !loginResult.isCancelled {
                    self.returnUserData(completionHandler: completionHandler)
                } else {
                    completionHandler(false, nil, nil)
                }
            }
        }
    }
    
    func returnUserData(completionHandler: @escaping ((Bool, String?, String?) -> Void)) {
        let me = GraphRequest(graphPath: "me", parameters: ["fields": "id"])
        let _ = me.start(completionHandler: { (connection, result, error) in
            if let _ = error {
                completionHandler(false, nil, nil)
            } else if let result = result as? [String : AnyObject] {
                let id = result["id"]
                let token = AccessToken.current?.tokenString
                completionHandler(true, id as? String, token)
            } else {
                completionHandler(false, nil, nil)
            }
        })
    }
}
