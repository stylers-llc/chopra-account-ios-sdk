//
//  ChopraSSO.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

import Foundation

public final class ChopraSSO {
    public static var googleClientId: String? {
        return GoogleHelper.shared.clientId
    }
    
    public static func setGoogleClientID(_ newId: String?) {
        GoogleHelper.shared.clientId = newId
    }
    
    public static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GoogleHelper.shared.application(app, open: url, options: options)
            || FacebookHelper.shared.application(app, open: url, options: options)
    }
    
    public static func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GoogleHelper.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
            || FacebookHelper.shared.application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
}
