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

@synthesize lblUsername;
@synthesize lblUserEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    
    [self.btnAddToContacts setBackgroundColor:  [UIColor colorWithRed:17.0f/255 green:173.0f/255 blue:210.0f/255 alpha:1]];
    self.view.backgroundColor = [UIColor colorWithRed:71.0f/255 green:146.0f/255 blue:162.0f/255 alpha:1];
    
    [lblUsername setText:@"John Doe"];
    [lblUserEmail setText:@"testemail@authoritypartners.com"];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,400, self.view.bounds.size.width, 1 )];
    lineView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:lineView];
    
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
