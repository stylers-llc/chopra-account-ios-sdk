//
//  ChopraAccount.m
//  SSOTestApplication
//
//  Created by Stylers on 2016. 01. 29..
//  Copyright © 2016. Stylers. All rights reserved.
//

#import "ChopraAccount.h"

@implementation ChopraAccount

- (NSString*)firstName {
    if (_firstName != (id)[NSNull null]) {
        return _firstName;
    }
    return nil;
}

- (NSString*)lastName {
    if (_lastName != (id)[NSNull null] ) {
        return _lastName;
    }
    return nil;
}

- (NSString*)birthDate {
    if (_birthDate != (id)[NSNull null] ) {
        return _birthDate;
    }
    return nil;
}

- (NSString*)email {
    if (_email != (id)[NSNull null] ) {
        return _email;
    }
    return nil;
}

- (NSString*)gender {
    if (_gender != (id)[NSNull null] ) {
        return _gender;
    }
    return nil;
}

- (NSString*)profileImage {
    if (_profileImage != (id)[NSNull null] ) {
        return _profileImage;
    }
    return nil;
}

- (NSString*)id {
    if (_id != (id)[NSNull null] ) {
        return _id;
    }
    return nil;
}

- (id)initFromJson:(id)json {
    
    self = [self init];
    if (self) {
        _firstName = (NSString*)[json objectForKey:@"first_name"];
        _lastName = (NSString*)[json objectForKey:@"last_name"];
        _email = (NSString*)[json objectForKey:@"email"];
        _id = [NSString stringWithFormat:@"%@", (NSNumber*)[json objectForKey:@"id"]];
        _gender = (NSString*)[json objectForKey:@"gender"];
        _birthDate = (NSString*)[json objectForKey:@"birthdate"];
        _profileImage = (NSString*)[json objectForKey:@"profile_image"];
    }
    return self;
}

@end
