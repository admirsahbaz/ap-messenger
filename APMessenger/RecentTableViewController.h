//
//  RecentTableViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentTableViewController : UITableViewController
@property (nonatomic, strong) NSString *reuseIdentifier;

@property (strong, nonatomic) NSMutableArray *recents;

+(void)cancelTimer;

@end
