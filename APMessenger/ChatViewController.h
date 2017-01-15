//
//  ChatViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSQMessages.h"

@interface ChatViewController : JSQMessagesViewController

@property (nonatomic, strong) JSQMessagesBubbleImage *incomingMessageBubble;
@property (nonatomic, strong) JSQMessagesBubbleImage *outgoingMessageBubble;
@property (nonatomic, strong) NSMutableArray *messages;

@end
