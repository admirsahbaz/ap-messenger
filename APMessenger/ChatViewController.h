//
//  ChatViewController.h
//  APMessenger
//
//  Created by Inela Avdic Hukic on 1/28/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "Message.h"
#import "LeftChatTableViewCell.h"
#import "RightChatTableViewCell.h"

@interface ChatViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic) NSInteger chatId;
@property (nonatomic, weak) NSString *chatPerson;

@end
