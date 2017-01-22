//
//  RestHelper.m
//  APMessenger
//
//  Created by Irvin Stevic on 1/17/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "RestHelper.h"

@implementation RestHelper

-(BOOL)checkLogin:(NSString*)username withPassword:(NSString*)password{
    return ([username isEqualToString: @"test@authoritypartners.com"] && [password isEqualToString:@"test"]);
}
@end
