//
//  PasswordViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/29/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "PasswordViewController.h"
#import "ThemeManager.h"
#import "RestHelper.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

ThemeManager * passwordThemeManager;

@synthesize currentPassword;
@synthesize password;
@synthesize confirmPassword;
@synthesize btnChangePassword;
@synthesize errorMessage;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    passwordThemeManager = [ThemeManager SharedInstance];
    self.currentPassword.borderStyle = UITextBorderStyleNone;
    self.password.borderStyle = UITextBorderStyleNone;
    self.confirmPassword.borderStyle = UITextBorderStyleNone;

    CALayer *borderPassword = [CALayer layer];
    CGFloat width1 = 2;
    borderPassword.borderColor = [[UIColor clearColor]CGColor];
    borderPassword.borderWidth = width1;
    borderPassword.frame = CGRectMake(0, self.currentPassword.frame.size.height, self.currentPassword.frame.size.width, self.currentPassword.frame.size.height);
    
    [self.view.layer addSublayer:borderPassword];
    

    self.currentPassword.placeholder = @"Current password";
    self.password.placeholder = @"Enter new password";
    self.confirmPassword.placeholder = @"Confirm new password";
    
    
    self.currentPassword.textColor = passwordThemeManager.textColor;
    self.password.textColor = passwordThemeManager.textColor;
    self.confirmPassword.textColor = passwordThemeManager.textColor;
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[passwordThemeManager.backgroundTopColor CGColor], (id)[passwordThemeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    [self.btnChangePassword setBackgroundColor:  [UIColor colorWithRed:17.0f/255 green:173.0f/255 blue:210.0f/255 alpha:1]];
    
    self.btnChangePassword.tintColor = passwordThemeManager.textColor;
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.title = @"Change password";
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.currentPassword resignFirstResponder];
    [self.password resignFirstResponder];
    [self.confirmPassword resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnChangePasswordClicked:(id)sender {

        /*NSString *pass = self.password.text;
        RestHelper *rest =  [RestHelper SharedInstance];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:pass, @"Password", nil];
        
        [rest requestPath:@"UpdatePassword" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleMessages:data withError:error];
            });
        }];*/
    //add validation when all fields are empty
    if(self.currentPassword.text.length == 0) {
        [self.errorMessage setText:@"Please enter your current password."];
    }
    
    else if(self.password.text.length ==0 ) {
        [self.errorMessage setText:@"Enter your new password."];
    }
    else if(self.confirmPassword.text.length ==0) {
        [self.errorMessage setText:@"Please confirm your new password."];
    }
    else if(self.password.text != self.confirmPassword.text) {
        [self.errorMessage setText:@"Your passwords were not maching."];
    } else{
        [self.errorMessage setText:@""];
}
}
- (void)handleMessages:(NSData*)data withError:(NSError*)error{
    if(error)
    {
        NSLog(@"ERROR: %@", error);
        self.errorMessage.text = error;

    }
    else{
        NSError *err = nil;
        [self.errorMessage setText:@"Your passwords is changed"];
    }
}

@end
