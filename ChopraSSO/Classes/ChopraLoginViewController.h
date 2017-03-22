//
//  ChopraLoginViewController.h
//  SSOTestApplication
//
//  Created by Stylers on 2016. 01. 26..
//  Copyright © 2016. Stylers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChopraAccount.h"

@interface ChopraLoginViewController : UIViewController <UIWebViewDelegate>

typedef enum {
    ChopraLoginTypeGoogle,
    ChopraLoginTypeFacebook,
    ChopraLoginTypeEmail
} ChopraLoginType;

-(void) setLoginBaseUrl:(NSString*)_baseUrl apiUrl:(NSString*)_apiUrl apiKey:(NSString*)_apiKey clientKey:(NSString*)_clientKey platform:(NSString*)_platform
              nameSpace:(NSString*)_nameSpace clientSecret:(NSString*)_clientSecret;

- (void) showEmailLoginViewFrom:(UIViewController*)rootViewController withHandler:(void(^)(NSString*,NSString*))handler;

- (void) showRegistrationViewFrom:(UIViewController*)rootViewController withHandler:(void(^)(NSString*,NSString*))handler;

- (void) loginWithFacebookFrom:(UIViewController*)rootViewController withHandler:(void(^)(NSString*,NSString*))handler;

- (void) loginWithGoogleFrom:(UIViewController*)rootViewController withHandler:(void(^)(NSString*,NSString*))handler;

- (void) getChopraAccountByUserKey:(NSString*)_uKey withHandler:(void(^)(ChopraAccount*))handler;

- (void) logout:(NSString*)_userKey;

@end
