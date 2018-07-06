//
//  SocialHelper.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

protocol SocialHelper {
    func login(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((_ success: Bool, _ userId: String?, _ userToken: String?) -> Void))
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool
}
