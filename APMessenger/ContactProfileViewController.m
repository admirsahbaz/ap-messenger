//
//  ContactProfileViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ContactProfileViewController.h"

@interface ContactProfileViewController ()

@end

@implementation ContactProfileViewController
@synthesize lblUserEmail;
@synthesize lblUserPhone;
@synthesize lblUserAddress;
@synthesize lblUserName;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [lblUserName setText:@"John Doe"];
    [lblUserAddress setText:@"Test Address, 90001, CA"];
    [lblUserPhone setText:@"123-456-789"];
    [lblUserEmail setText:@"testemail@api.com"];
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
