//
//  ChopraSSO.m
//  Pods
//
//  Created by Örs Kovács on 2017. 03. 20..
//
//

#import <Foundation/Foundation.h>

#import "ChopraSSO.h"
#import "FacebookHelper.h"
#import "GoogleHelper.h"

@implementation ChopraSSO

static NSString* _googleClientID;

+(void)setGoogleClientID:(NSString *)googleClientID {
    _googleClientID = googleClientID;
    [[GoogleHelper sharedInstance] setClientID:googleClientID];
}

+(NSString *)googleClientID {
    return _googleClientID;
}

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[FacebookHelper sharedInstance] application:app openURL:url options:options] ||
            [[GoogleHelper sharedInstance] application:app openURL:url options:options];
}

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
            annotation:(id)annotation {
    return [[FacebookHelper sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation] ||
            [[GoogleHelper sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end

