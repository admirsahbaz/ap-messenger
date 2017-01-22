//
//  ContactProfileViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblUserEmail;

@property (weak, nonatomic) IBOutlet UIButton *btnAddToContacts;

@end
