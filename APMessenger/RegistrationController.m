//
//  RegistrationController.m
//  APMessenger
//
//  Created by Irvin Stevic on 2/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "RegistrationController.h"
#import "ThemeManager.h"
#import "RestHelper.h"

@interface RegistrationController ()

@end

@implementation RegistrationController

@synthesize emailTxt;
@synthesize nameTxt;
@synthesize password1Txt;
@synthesize password2Txt;
@synthesize messageLabel;
@synthesize loadingSpinner;
@synthesize registerBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/UpdateLastActivity" withData:nil andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    [messageLabel setText:@""];
    ThemeManager *themeManager = [[ThemeManager alloc] init];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[themeManager.backgroundTopColor CGColor], (id)[themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    self.emailTxt.placeholder = @"Enter your e-mail";
    self.password1Txt.placeholder = @"Enter password";
    self.nameTxt.placeholder= @"Enter your name";
    self.password2Txt.placeholder= @"Repeat password";
    
    self.emailTxt.borderStyle = UITextBorderStyleNone;
    self.password1Txt.borderStyle = UITextBorderStyleNone;
    self.password2Txt.borderStyle = UITextBorderStyleNone;
    self.nameTxt.borderStyle = UITextBorderStyleNone;
    self.emailTxt.delegate = self;
    self.nameTxt.delegate = self;
    self.password1Txt.delegate = self;
    self.password2Txt.delegate = self;
    
    CALayer *border = [CALayer layer];
    CGFloat borderWidth1 = 0.3;
    border.borderColor = [[UIColor whiteColor] CGColor];
    border.borderWidth = borderWidth1;
    border.frame = CGRectMake(0, self.password1Txt.frame.size.height- borderWidth1, self.password1Txt.frame.size.width, self.password1Txt.frame.size.height);
    
    [self.password1Txt.layer addSublayer:border];
    self.password1Txt.layer.masksToBounds = YES;
    
    CALayer *borderEmail = [CALayer layer];
    CGFloat borderWidth2 = 0.3;
    borderEmail.borderColor = [[UIColor whiteColor] CGColor];   borderEmail.borderWidth = borderWidth2;
    borderEmail.frame = CGRectMake(0, self.emailTxt.frame.size.height- borderWidth2, self.emailTxt.frame.size.width, self.emailTxt.frame.size.height);
    
    [self.emailTxt.layer addSublayer:borderEmail];
    self.emailTxt.layer.masksToBounds = YES;
    
    CALayer *borderName = [CALayer layer];
    CGFloat borderWidth3 = 0.3;
    borderName.borderColor = [[UIColor whiteColor] CGColor];   borderName.borderWidth = borderWidth3;
    borderName.frame = CGRectMake(0, self.nameTxt.frame.size.height- borderWidth3, self.nameTxt.frame.size.width, self.nameTxt.frame.size.height);
    
    [self.nameTxt.layer addSublayer:borderName];
    self.nameTxt.layer.masksToBounds = YES;

    CALayer *borderPass2= [CALayer layer];
    CGFloat borderWidth4 = 0.3;
    borderPass2.borderColor = [[UIColor whiteColor] CGColor];   borderPass2.borderWidth = borderWidth4;
    borderPass2.frame = CGRectMake(0, self.password2Txt.frame.size.height- borderWidth4, self.password2Txt.frame.size.width, self.password2Txt.frame.size.height);
    
    [self.password2Txt.layer addSublayer:borderPass2];
    self.password2Txt.layer.masksToBounds = YES;
    
    
    [self.registerBtn setBackgroundColor:  [UIColor colorWithRed:17.0f/255 green:173.0f/255 blue:210.0f/255 alpha:1]];
    
    self.registerBtn.tintColor = themeManager.textColor;

    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.emailTxt resignFirstResponder];
    [self.nameTxt resignFirstResponder];
    [self.password1Txt resignFirstResponder];
    [self.password2Txt resignFirstResponder];
}

- (void)completeRegistration:(NSData*)data withError:(NSError*)error{
    registerBtn.enabled = true;
    [loadingSpinner stopAnimating];
    //NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    if(error)
    {
        NSLog(@"ERROR: %@", error);
        [messageLabel setHidden:NO];
        [messageLabel setText:@"An error ocurred"];
    }
    else{
        NSError *err = nil;
        if(!data){
            [messageLabel setHidden:NO];
            [messageLabel setText:@"An error ocurred"];
            return;
        }
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        NSString *message = [dict objectForKey:@"message"];
        if(message == nil){
            [messageLabel setHidden:NO];
            [messageLabel setText:@"An error ocurred"];
            return;
        }
        else if(![message isEqualToString:@""]){
            [messageLabel setHidden:NO];
            [messageLabel setText:message];
            return;
        }
        //[messageLabel setHidden:NO];
        //[messageLabel setText:@"Registration Completed"];
    }
}

- (IBAction)registerBtnClicked:(id)sender {
    [messageLabel setHidden:YES];
    NSString *un = [self.emailTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    NSString *displayName = [self.nameTxt.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    NSString *pass1 = [self.password1Txt.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    NSString *pass2 = [self.password2Txt.text stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];
    if([un isEqualToString:@""] || [pass1 isEqualToString:@""] || [pass2 isEqualToString:@""] || [displayName isEqualToString:@""]){
        [messageLabel setHidden:NO];
        [messageLabel setText:@"Please fill all fields"];
        return;
    }
    else if(![pass1 isEqualToString:pass2]){
        [messageLabel setHidden:NO];
        [messageLabel setText:@"Passwords must match"];
        return;
    }
    else{
        registerBtn.enabled = false;
        [loadingSpinner startAnimating];
        RestHelper *rest =  [RestHelper SharedInstance];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:un, @"Email", pass1, @"Password", displayName, @"DisplayName", nil];
        
        [rest requestPath:@"/Register" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self completeRegistration:data withError:error];
            });
        }];
    }

}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self animateTextField:textField up:NO];
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up {
    const int movementDistance = -210;
    const float movementDuration = 0.3f;
    
    int movement = (up ? movementDistance : -movementDistance);
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
