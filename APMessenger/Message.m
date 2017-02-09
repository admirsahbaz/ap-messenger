//
//  Message.m
//  APMessenger
//
//  Created by Inela Avdic Hukic on 1/29/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithText:(NSString *)text sender:(NSString *)sender receiver:(NSString *)receiver time:(NSDate *)time isSender:(BOOL *)isSender {
    self = [super init];
    if(self) {
        self.text = text;
        self.sender = sender;
        self.receiver = receiver;
        self.time = time;
        self.isSender = isSender;
    }
    return self;
}


@end
