//
//  ContactProfileViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ContactProfileViewController.h"
#import "ThemeManager.h"
#import "RestHelper.h"
@interface ContactProfileViewController ()

@end

@implementation ContactProfileViewController

@synthesize lblUsername;
@synthesize lblUserEmail;
@synthesize profilePicture;
@synthesize picture;

ThemeManager *_themeManager;


- (void)viewDidLoad {

    [super viewDidLoad];
    
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/UpdateLastActivity" withData:nil andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    // Do any additional setup after loading the view.
    _themeManager = [ThemeManager SharedInstance];
    [self.profilePicture setImage:[UIImage imageNamed:@"contactimg.jpg"]];
    
    [self.picture setImage:[UIImage imageNamed:@"contactimg.jpg"]];
    self.picture.layer.cornerRadius = 50;
    self.picture.layer.borderWidth = 2.0;
    self.picture.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.picture.layer.masksToBounds = YES;
    
    
    //backgorund color
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[_themeManager.backgroundTopColor CGColor], (id)[_themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    //button for adding new contact
    [self.btnAddToContacts setBackgroundColor:  [UIColor colorWithRed:17.0f/255 green:173.0f/255 blue:210.0f/255 alpha:1]];
    
    //text color
    lblUsername.textColor = _themeManager.textColor;
    lblUserEmail.textColor = _themeManager.textColor;
       
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem: self.btnAddToContacts attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem:self.view attribute: NSLayoutAttributeBottom multiplier:2.0f constant: 400.f];
    
    [self.view addConstraint: bottom];
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

@end
