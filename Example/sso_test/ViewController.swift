//
//  ViewController.swift
//  sso_test
//
//  Created by Örs Kovács on 2017. 01. 24..
//  Copyright © 2017. EN-CO Software Kft. All rights reserved.
//

import UIKit
import ChopraSSO

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.red
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
    }
    
    func tapped(_ sender: UITapGestureRecognizer?) {
        let chopra = ChopraLoginViewController()
        
        chopra.setLoginBaseUrl(ServerProxyConstants.authUrl, apiUrl: ServerProxyConstants.authApiUrl, apiKey: ServerProxyConstants.authApiKey, clientKey: ServerProxyConstants.clientKey, platform: ServerProxyConstants.authPlatform, nameSpace: ServerProxyConstants.namespace, clientSecret: ServerProxyConstants.clientSecret)
        
        chopra.showEmailLoginView(from: self) { (uId, uToken) -> Void in
            
            if let uToken = uToken {
                chopra.getChopraAccount(byUserKey: uToken, withHandler: { (chopraAccount) -> Void in
                    let acc = chopraAccount
                    print(acc?.gender)
                })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

struct ServerProxyConstants {
    
    #if DEBUG
    private static let test: Bool = false
    #else
    private static let test: Bool = false
    #endif
    
    static let baseUrl: String = {
        //        ÉLES URL:
        if !test {
            return "http://fleet-api.chopraananda.com/v1/" // "http://api.choprananda.com/v1/"
        }
        //        TESZT URL:
        return "http://dev-api.chopraananda.com/v1/"
    }()
    
    static let apiKey: String = {
        //        ÉLES
        if !test {
            return "55zhNvDdN9HrgqFhLa373bXDuTvPwCfQ7OpO3Mbq"
        }
        //        TESZT
        return "55zhNvDdN9HrgqFhLa373bXDuTvPwCfQ7OpO3Mbq"
    }()
    
    static let namespace: String = {
        //        ÉLES
        if !test {
            return "ios.mobile.ananda"
        }
        //        TESZT
        return "ananda.mobile.ios"
    }()
    
    static let clientKey: String = {
        //        ÉLES
        if !test {
            return "WPCdJPNhWW"
        }
        //        TESZT
        return "7N8MA8TgNy"
    }()
    
    static let clientSecret: String = {
        //        ÉLES
        if !test {
            return "ONZl6eqjDeAcRmmWev7jdSnlqJ1wC8nt"
        }
        //        TESZT
        return "Sa9aZeE95aCktudHmiKMniQNY4smG3HS"
    }()
    
    static let authUrl: String = {
        //        ÉLES
        if !test {
            return "https://account.chopra.com"
        }
        //        TESZT
        return "http://dev-account.chopra.com"
    }()
    
    static let authApiUrl: String = {
        //        ÉLES
        if !test {
            return "https://account-api.chopra.com"
        }
        //        TESZT
        return "http://dev-account-api.chopra.com"
    }()
    
    static let authPlatform: String = {
        //        ÉLES
        if !test {
            return "mobile"
        }
        //        TESZT
        return "mobile"
    }()
    
    static let authApiKey: String = {
        //        ÉLES
        if !test {
            return "8yj7d28u2K1UWCCk"
        }
        //        TESZT
        return "NFpOkLLaXI6a88pi"
    }()
    
}

struct ServerMethods {
    static let login = "auth"
    static let refreshToken = "auth/refresh_token"
    
    static let playlists = "playlist"
    static let playlistDetails = "playlist/%d"
    static let combinations = "combination"
    static let combinationDetails = "combination/%d"
    static let suggestionsDailySpecial = "suggestion/position/daily_special"
    static let suggestionsWeeklySpecial = "suggestion/position/currently_trending"
    static let selectionList = "selection"
    static let selectionDetails = "selection/%d/content"
    
    static let userSettings = "user/%@/settings"
    
    static let myPlaylists = "user/%@/playlist"
    static let myPlaylistDetails = "user/%@/playlist/%d"
    static let voiceToPlaylist = "user/%@/playlist/%d/voice/%d"
    static let musicToPlaylist = "user/%@/playlist/%d/music/%d"
    static let inAppReceipt = "subscription/itunes"
    static let search = "search"
    static let searchPlaylists = "search/playlist"
    static let searchCombinations = "search/combination"
    
    static let helpCategories = "help/category"
    static let paymentHelpCategory = "help/category/%@"
    static let department = "osticket/department/%@"
    static let departmentTopics = "osticket/department/%@/topics"
    static let ticket = "osticket/ticket"
    
    static let bannerPosition = "banner/position/%@"
    
    static let subscription = "user/%@/mail/subscription"
    static let subscribeToList = "user/%@/mail/subscription/list/%@"
    static let subscribeToInterest = "user/%@/mail/subscription/interest/%@"
}

struct ServerParameters {
    static let success = "success"
    
    static let errors = "errors"
    static let errorId = "id"
    static let errorStatus = "status"
    static let errorTitle = "title"
    static let errorDetail = "detail"
    
    static let ssoToken = "sso_token"
    
    static let name = "name"
    
    static let receipt = "receipt"
    
    static let term = "term"
    
    static let perPage = "per_page"
    
    static let balance = "balance"
    static let meditationLength = "meditation_length"
    
    static let platform = "platform"
    static let platformIOS = "2"
    static let currentDepartmentId = "24"
    static let splashScreenBanner = "splash_screen"
    
    static let customerName = "customer_name"
    static let customerEmail = "customer_email"
    static let subject = "subject"
    static let message = "message"
    static let topicId = "topic_id"
    static let departmentId = "department_id"
    
    static let paymentHelpCategoryId = "0"
    
}

struct ErrorCodes {
    static let upToDateList = 2012
    static let missingRegistration = 2003
}

