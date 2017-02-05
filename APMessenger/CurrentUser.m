//
//  CurrentUser.m
//  APMessenger
//
//  Created by Irvin Stevic on 2/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "CurrentUser.h"

@implementation CurrentUser

@synthesize userToken = _token;

-(id)init{
    if(self == [super init]){
        _token = nil;
    }
    return self;
}

+(CurrentUser *)Current{
    static CurrentUser *impl;
    static dispatch_once_t oToken;
    
    dispatch_once(&oToken, ^{
        impl = [[self alloc]init];
    });
    return impl;
}

-(NSString *) LogInUser:(NSString *)token{
    _token = token;
    return _token;
}

-(NSString *) LogOutUser{
    _token = nil;
    return @"";
}

@end
