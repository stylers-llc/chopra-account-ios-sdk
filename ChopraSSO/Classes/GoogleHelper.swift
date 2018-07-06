//
//  GoogleHelper.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

import GoogleSignIn

class GoogleHelper: NSObject, SocialHelper, GIDSignInDelegate, GIDSignInUIDelegate {
    
    static var shared: GoogleHelper = GoogleHelper()
    
    var clientId: String? {
        didSet {
            GIDSignIn.sharedInstance().clientID = clientId
        }
    }
    
    var rootViewController: UIViewController?
    var completionHandler: ((Bool, String?, String?) -> Void)?
    var isSilent: Bool = true
    
    override init() {
        super.init()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func login(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((Bool, String?, String?) -> Void)) {
        self.rootViewController = rootViewController
        self.completionHandler = completionHandler
        
        self.isSilent = true
        GIDSignIn.sharedInstance().signInSilently()
    }
    
    // MARK: - GIDSignInDelegate
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let _ = error {
            if self.isSilent {
                self.isSilent = false
                GIDSignIn.sharedInstance().signIn()
            } else {
                self.completionHandler?(false, nil, nil)
                self.completionHandler = nil
            }
        } else {
            let id = user.userID
            let token = user.authentication.accessToken
            self.completionHandler?(true, id, token)
            self.completionHandler = nil
            GIDSignIn.sharedInstance().signOut()
        }
    }
    
    // MARK: - GIDSignInUIDelegate
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        if self.isSilent {
            self.isSilent = false
            GIDSignIn.sharedInstance().signIn()
        } else {
            self.completionHandler?(false, nil, nil)
            self.completionHandler = nil
        }
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.rootViewController?.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        viewController.dismiss(animated: true, completion: nil)
        self.rootViewController = nil
    }
}
