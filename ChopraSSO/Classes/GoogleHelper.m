//
//  GoogleHelper.m
//  Pods
//
//  Created by Örs Kovács on 2017. 03. 20..
//
//

#import <UIKit/UIKit.h>

#import "GoogleHelper.h"

@interface GoogleHelper ()
{
    void (^_completionHandler)(Boolean success, NSString* userId, NSString* userToken);
    BOOL _silentSignIn;
    UIViewController* _rootViewController;
}

@end

@implementation GoogleHelper

+ (instancetype)sharedInstance
{
    static GoogleHelper *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GoogleHelper alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[GIDSignIn sharedInstance] setDelegate: self];
        [[GIDSignIn sharedInstance] setUiDelegate: self];
    }
    return self;
}

-(void)setClientID:(NSString *)clientID {
    [[GIDSignIn sharedInstance] setClientID: clientID];
}

-(void)loginFrom:(UIViewController *)rootViewController withHandler:(void (^)(Boolean, NSString *, NSString *))handler {
    _silentSignIn = YES;
    _rootViewController = rootViewController;
    _completionHandler = handler;
    [[GIDSignIn sharedInstance] signInSilently];
}

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey] annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
            annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url sourceApplication:sourceApplication annotation:annotation];
}

#pragma mark GIDSignInDelegate

-(void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (!error) {
        NSString* id = user.userID;
        NSString* token = user.authentication.accessToken;
        _completionHandler(true, id, token);
        _completionHandler = nil;
        [[GIDSignIn sharedInstance] signOut];
    } else if (_silentSignIn) {
        _silentSignIn = NO;
        [[GIDSignIn sharedInstance] signIn];
    } else {
        _completionHandler(false, @"", @"");
        _completionHandler = nil;
    }
}

-(void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    if (_silentSignIn) {
        _silentSignIn = NO;
        [[GIDSignIn sharedInstance] signIn];
    } else {
        _completionHandler(false, @"", @"");
        _completionHandler = nil;
    }
}

#pragma mark GIDSignInUIDelegate

-(void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController {
    [_rootViewController presentViewController:viewController animated:YES completion:nil];
}

-(void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
    _rootViewController = nil;
}

@end
