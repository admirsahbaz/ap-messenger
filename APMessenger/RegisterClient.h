//
//  RegisterClient.h
//  APMessenger
//
//  Created by Samer Abud on 3/7/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterClient : NSObject

@property (strong, nonatomic) NSString* authenticationHeader;

-(void) registerWithDeviceToken:(NSData*)token tags:(NSSet*)tags
                  andCompletion:(void(^)(NSError*))completion;

-(instancetype) initWithEndpoint:(NSString*)Endpoint;

@end
