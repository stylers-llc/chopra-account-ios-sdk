//
//  GoogleHelper.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

import GoogleSignIn

class GoogleHelper: NSObject, SocialHelper, GIDSignInDelegate {
    
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
    }
    
    func application(open url: URL) -> Bool {
        return GIDSignIn.sharedInstance()?.handle(url) ?? false
    }
    
    func login(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((Bool, String?, String?) -> Void)) {
        GIDSignIn.sharedInstance()?.presentingViewController = rootViewController
        self.rootViewController = rootViewController
        self.completionHandler = completionHandler
        
        self.isSilent = true
        GIDSignIn.sharedInstance()?.restorePreviousSignIn()
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
}
