//
//  FacebookHelper.m
//  Pods
//
//  Created by Örs Kovács on 2017. 03. 20..
//
//

#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FacebookHelper.h"

@interface FacebookHelper ()
{
    void (^_completionHandler)(Boolean success, NSString* userId, NSString* userToken);
}

@end

@implementation FacebookHelper

NSArray* readPermissions;
FBSDKLoginManager* loginManager;

+ (instancetype)sharedInstance
{
    static FacebookHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FacebookHelper alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        readPermissions = [NSArray arrayWithObjects: @"public_profile", @"email", nil];
        loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager setLoginBehavior:FBSDKLoginBehaviorSystemAccount];
    }
    return self;
}

- (void) returnUserData {
    FBSDKGraphRequest* graphRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id"}];
    [graphRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        if (error) {
            _completionHandler(false, @"", @"");
            _completionHandler = nil;
        } else {
            NSString* id = [result valueForKey:@"id"];
            NSString* token = [[FBSDKAccessToken currentAccessToken] tokenString];
            _completionHandler(true, id, token);
            _completionHandler = nil;
        }
        [loginManager logOut];
    }];
}
- (void) loginFrom:(UIViewController*)rootViewController withHandler:(void(^)(Boolean success,NSString* userId,NSString* userToken))handler {
    if ([FBSDKAccessToken currentAccessToken]) {
        _completionHandler = handler;
        [self returnUserData];
    } else {
        [loginManager logInWithReadPermissions:readPermissions fromViewController:rootViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            if (result && !result.isCancelled) {
                _completionHandler = handler;
                [self returnUserData];
            } else {
                handler(false, @"", @"");
            }
        }];
    }
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:app openURL:url options:options];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
            annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
