//
//  ChopraSSO.h
//  Pods
//
//  Created by Örs Kovács on 2017. 01. 24..
//
//

#import <Foundation/Foundation.h>
#import "ChopraAccount.h"
#import "ChopraLoginViewController.h"

@interface ChopraSSO : NSObject

+ (NSString*) googleClientID;
+ (void)setGoogleClientID:(NSString *)googleClientID;

+ (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options;

+ (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
            annotation:(id)annotation;
@end
