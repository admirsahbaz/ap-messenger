//
//  ContactProfileViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ContactProfileViewController.h"
#import "ThemeManager.h"

@interface ContactProfileViewController ()

@end

@implementation ContactProfileViewController

@synthesize lblUsername;
@synthesize lblUserEmail;

ThemeManager *_themeManager;


- (void)viewDidLoad {

    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    _themeManager = [[ThemeManager alloc] init];
    
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
    
    //mock data
    [lblUsername setText:@"John Doe"];
    [lblUserEmail setText:@"testemail@authoritypartners.com"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,400, self.view.bounds.size.width, 1 )];
    lineView.backgroundColor = _themeManager.textColor;
    
    [self.view addSubview:lineView];
    
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0,600, self.view.bounds.size.width, 1 )];
    bottomLine.backgroundColor = _themeManager.textColor;
    [self.view addSubview:bottomLine];

    [self.view addSubview:lineView];    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem: self.btnAddToContacts attribute: NSLayoutAttributeBottom relatedBy: NSLayoutRelationEqual toItem:self.view attribute: NSLayoutAttributeBottom multiplier:1.0f constant: 0.f];
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
