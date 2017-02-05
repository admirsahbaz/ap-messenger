//
//  ViewController.m
//  APMessenger
//
//  Created by Admir Sahbaz on 12/25/16.
//  Copyright © 2016 Authority Partners. All rights reserved.
//

#import "ViewController.h"
#import "RestHelper.h"
#import "ThemeManager.h"
#import "CurrentUser.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize userNameTxt;
@synthesize passwordTxt;
@synthesize invalidLoginMessage;
@synthesize loadingSpinner;
@synthesize loginBtn;
@synthesize btnCreateAccount;
@synthesize lblEmail;
@synthesize lblPassword;

ThemeManager *theme;

- (void)viewDidLoad {
    theme = [ThemeManager SharedInstance];
    
    [super viewDidLoad];
    [loadingSpinner setHidden:YES];
    self.userNameTxt.placeholder = @"Enter your e-mail";
    self.passwordTxt.placeholder = @"Enter password";
    
    self.passwordTxt.borderStyle = UITextBorderStyleNone;
    self.userNameTxt.borderStyle = UITextBorderStyleNone;
    
    self.passwordTxt.textColor = theme.textColor;
    self.userNameTxt.textColor = theme.textColor;
    self.lblPassword.textColor = theme.textColor;
    self.lblEmail.textColor = theme.textColor;
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth = 2;
    border.borderColor = [[UIColor lightGrayColor] CGColor];   border.borderWidth = borderWidth;
    border.frame = CGRectMake(0, self.passwordTxt.frame.size.height- borderWidth, self.passwordTxt.frame.size.width, self.passwordTxt.frame.size.height);
    
    [self.passwordTxt.layer addSublayer:border];
    self.passwordTxt.layer.masksToBounds = YES;
    
    CALayer *borderPass = [CALayer layer];
    CGFloat width = 2;
    borderPass.borderColor = [[UIColor lightGrayColor]CGColor];
    borderPass.borderWidth = width;
    borderPass.frame = CGRectMake(0, self.passwordTxt.frame.size.height- width, self.passwordTxt.frame.size.width, self.passwordTxt.frame.size.height);
    
    [self.userNameTxt.layer addSublayer:borderPass];
    self.userNameTxt.layer.masksToBounds = YES;
    
    
    //backgorund color
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[theme.backgroundTopColor CGColor], (id)[theme.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    [self.loginBtn setBackgroundColor:  [UIColor colorWithRed:17.0f/255 green:173.0f/255 blue:210.0f/255 alpha:1]];

    self.loginBtn.tintColor = theme.textColor;
    self.btnCreateAccount.tintColor = theme.textColor;
    
    //self.userNameTxt.delegate = self;
    //self.passwordTxt.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.userNameTxt resignFirstResponder];
    [self.passwordTxt resignFirstResponder];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if([identifier isEqualToString:@"LoginSegue"])
        return NO;
    return YES;
}

- (void)authenticate:(NSData*)data withError:(NSError*)error{
    loginBtn.enabled = true;
    [loadingSpinner stopAnimating];
    [loadingSpinner setHidden:YES];
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    if(error)
    {
        NSLog(@"ERROR: %@", error);
    }
    else if([str isEqualToString:@"null"])
    {
        [invalidLoginMessage setHidden:NO];
    }
    else{
        CurrentUser *user = [CurrentUser Current];
        [user LogInUser: str];
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
}

- (IBAction)logInButtonClicked:(id)sender {
    loginBtn.enabled = false;
    [loadingSpinner setHidden:NO];
    [loadingSpinner startAnimating];
    [invalidLoginMessage setHidden:YES];
    NSString *un = self.userNameTxt.text;
    NSString *pass = self.passwordTxt.text;
    RestHelper *rest =  [RestHelper SharedInstance];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:un, @"Email", pass, @"Password", nil];
    
    [rest requestPath:@"/login" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self authenticate:data withError:error];
        });
    }];
}


@end
