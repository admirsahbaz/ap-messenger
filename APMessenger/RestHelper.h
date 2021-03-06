//
//  RestHelper.h
//  APMessenger
//
//  Created by Irvin Stevic on 1/17/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RestHelper : NSObject

typedef void(^RequestCompletionHandler)(NSData*, NSError*);

-(void)requestPath:(NSString *)path withData:(NSDictionary*)params andHttpMethod:(NSString*)method onCompletion:(RequestCompletionHandler)complete;

+ (RestHelper *) SharedInstance;

@end
