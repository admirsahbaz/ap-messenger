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

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (void)testFn:(NSData*)data withError:(NSError*)error{
    NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    if(error)
        NSLog(@"ERROR: %@", error);
    [invalidLoginMessage setHidden:NO];
    [invalidLoginMessage setText:str];
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
}

- (IBAction)logInButtonClicked:(id)sender {
    [invalidLoginMessage setHidden:YES];
    NSString *un = self.userNameTxt.text;
    NSString *pass = self.passwordTxt.text;
    RestHelper *rest = [[RestHelper alloc]init];
    bool login = [rest checkLogin:un withPassword:pass];
    login = NO;
    [rest requestPath:@"" withData:NULL andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self testFn:data withError:error];
        });
        
    }];
    if(login)
    {
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
        //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        
        //UIViewController * vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"FBOut"];
        //[self presentViewController:vc animated:YES completion:nil];
    }
    else{
        //[invalidLoginMessage setHidden:NO];
    }
}


@end
