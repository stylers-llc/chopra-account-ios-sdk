//
//  SocialHelper.swift
//  ChopraSSO
//
//  Created by Örs Kovács on 2018. 06. 22..
//

protocol SocialHelper {
    func login(from rootViewController: UIViewController, withHandler completionHandler: @escaping ((_ success: Bool, _ userId: String?, _ userToken: String?) -> Void))
}
