//
//  RestHelper.h
//  APMessenger
//
//  Created by Irvin Stevic on 1/17/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHelper : NSObject

-(BOOL)checkLogin:(NSString*)username withPassword:(NSString*)password;

@end
