//
//  ViewController.h
//  APMessenger
//
//  Created by Admir Sahbaz on 12/25/16.
//  Copyright © 2016 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *userNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UILabel *invalidLoginMessage;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingSpinner;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

