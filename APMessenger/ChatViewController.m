//
//  ChatViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ChatViewController.h"

static NSString * const senderId = @"random-sender-id";
static NSString * const senderName = @"Test Sender";
static NSString * const myId = @"my-id";
static NSString * const myName = @"Test Receiver";

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = senderName;
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(30.0, 30.0);
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(30.0, 30.0);
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    self.outgoingMessageBubble = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingMessageBubble = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    
    self.messages = [[NSMutableArray alloc] initWithObjects:
                         [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderName date:[NSDate distantPast] text:@"I am testing api messenger"],
                         [[JSQMessage alloc] initWithSenderId:myId senderDisplayName:myName date:[NSDate distantPast] text:@"Works great... haha!"],
                         nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - JSQMessagesViewController method overrides

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date
{
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId
                                             senderDisplayName:senderDisplayName
                                                          date:date
                                                          text:text];
    
    [self.messages addObject:message];
    [self finishSendingMessageAnimated:YES];
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    // implement accessory button handling
}


#pragma mark - JSQMessages CollectionView DataSource

- (NSString *)senderId {
    return senderId;
}

- (NSString *)senderDisplayName {
    return senderName;
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.row];
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingMessageBubble;
    }
    return self.incomingMessageBubble;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        // return avatar of sender
        UIImage *avatarImage = [UIImage imageNamed:@"DefaultUserIcon"];
        return [[JSQMessagesAvatarImage alloc] initWithAvatarImage:avatarImage highlightedImage:avatarImage placeholderImage:avatarImage];
    }
    else {
        // return my avatar
        UIImage *avatarImage = [UIImage imageNamed:@"DefaultUserIcon"];
        return [[JSQMessagesAvatarImage alloc] initWithAvatarImage:avatarImage highlightedImage:avatarImage placeholderImage:avatarImage];
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.row];
    if (!msg.isMediaMessage) {
        
        if ([msg.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor blackColor];
        }
        else {
            cell.textView.textColor = [UIColor whiteColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                              NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    
    return cell;
}

#pragma mark - Action methods

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

@end
