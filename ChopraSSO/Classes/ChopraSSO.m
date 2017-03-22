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
    return [[FacebookHelper sharedInstance] application:app openURL:url options:options];
}

@end

