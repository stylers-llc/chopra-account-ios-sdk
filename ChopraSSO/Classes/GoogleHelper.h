//
//  GoogleHelper.h
//  Pods
//
//  Created by Örs Kovács on 2017. 03. 20..
//
//

#import "SocialHelper.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface GoogleHelper : NSObject <SocialHelperProtocol, GIDSignInDelegate, GIDSignInUIDelegate>

@property NSString* clientID;

@end
