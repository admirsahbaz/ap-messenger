//
//  Message.h
//  APMessenger
//
//  Created by Inela Avdic Hukic on 1/29/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property NSString *text;
@property NSString *sender;
@property NSString *receiver;
@property NSDate *time;
@property BOOL *isSender;

- (instancetype)initWithText:(NSString *)text sender:(NSString *)sender receiver:(NSString *)receiver time:(NSDate *)time isSender:(BOOL *)isSender;

@end
