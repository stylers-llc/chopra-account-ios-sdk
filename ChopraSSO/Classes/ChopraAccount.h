//
//  ChopraAccount.h
//  SSOTestApplication
//
//  Created by Stylers on 2016. 01. 29..
//  Copyright © 2016. Stylers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChopraAccount : NSObject

@property (retain, nullable, nonatomic) NSString* firstName;
@property (retain, nullable, nonatomic) NSString* lastName;
@property (retain, nullable, nonatomic) NSString* email;
@property (retain, nullable, nonatomic) NSString* birthDate;
@property (retain, nullable, nonatomic) NSString* gender;
@property (retain, nullable, nonatomic) NSString* profileImage;
@property (retain, nullable, nonatomic) NSString* id;

- (_Nullable id)initFromJson:(_Nonnull id)json;

@end
