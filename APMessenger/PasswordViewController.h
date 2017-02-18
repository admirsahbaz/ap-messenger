//
//  PasswordViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/29/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *currentPassword;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@property (weak, nonatomic) IBOutlet UIButton *btnChangePassword;
- (IBAction)btnChangePasswordClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end
