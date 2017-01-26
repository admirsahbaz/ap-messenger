//
//  ViewController.m
//  APMessenger
//
//  Created by Admir Sahbaz on 12/25/16.
//  Copyright © 2016 Authority Partners. All rights reserved.
//

#import "ViewController.h"
#import "RestHelper.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize userNameTxt;
@synthesize passwordTxt;
@synthesize invalidLoginMessage;
@synthesize loadingSpinner;
@synthesize loginBtn;

- (void)viewDidLoad {
    [super viewDidLoad];
    [loadingSpinner setHidden:YES];
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
    RestHelper *rest = [[RestHelper alloc]init];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:un, @"Email", pass, @"Password", nil];
    
    [rest requestPath:@"/login" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self authenticate:data withError:error];
        });
    }];
}


@end
