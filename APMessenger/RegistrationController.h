//
//  RegistrationController.h
//  APMessenger
//
//  Created by Irvin Stevic on 2/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextField *password1Txt;
@property (weak, nonatomic) IBOutlet UITextField *password2Txt;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;

@end
