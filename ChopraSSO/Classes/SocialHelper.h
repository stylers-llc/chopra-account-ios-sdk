//
//  SocialHelper.h
//  Pods
//
//  Created by Örs Kovács on 2017. 03. 20..
//
//

#import <Foundation/Foundation.h>

@protocol SocialHelperProtocol

+ (instancetype)sharedInstance;

- (void) loginFrom:(UIViewController*)rootViewController withHandler:(void(^)(Boolean success,NSString* userId,NSString* userToken))handler;
- (BOOL) application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

@end
