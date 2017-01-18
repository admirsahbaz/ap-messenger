//
//  ContactProfileViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactProfileViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblUserPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblUserEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblUserAddress;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@end
