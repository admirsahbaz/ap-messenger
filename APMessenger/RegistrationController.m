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
    
    [messageLabel setText:@""];
    ThemeManager *themeManager = [[ThemeManager alloc] init];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[themeManager.backgroundTopColor CGColor], (id)[themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
