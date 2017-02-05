//
//  CurrentUser.h
//  APMessenger
//
//  Created by Irvin Stevic on 2/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUser : NSObject

@property (strong, retain) NSString *userToken;

-(NSString *) LogInUser:(NSString *)token;

-(NSString *) LogOutUser;

+(CurrentUser *) Current;

@end
