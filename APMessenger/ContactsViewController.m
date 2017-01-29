//
//  ContactsViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ContactsViewController.h"
#import "ThemeManager.h"

@interface ContactsViewController ()
@end

@implementation ContactsViewController

@synthesize contacts = _contacts;
@synthesize identifier = _identifier;

ThemeManager *themeManager;

- (void)viewDidLoad {
    [super viewDidLoad];    
    
    themeManager = [[ThemeManager alloc] init];

    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[themeManager.backgroundTopColor CGColor], (id)[themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    _contacts = [[NSMutableDictionary alloc] init];
    
    NSString *contactsJsonString = @"[{\"Name\":\"Dorian\",\"Status\":\"688BD74E-8816-A3E9-B9EA-B73DA26C5855\"},{\"Name\":\"Caldwell\",\"Status\":\"91B955BD-EB62-4A02-BA65-3B6C75578A61\"},{\"Name\":\"Craig\",\"Status\":\"8588A9F9-0588-36AB-97A7-8EB8B3381782\"},{\"Name\":\"Dale\",\"Status\":\"93930E1E-D8F5-BF81-D7DD-32FE7A3DD55E\"},{\"Name\":\"Derek\",\"Status\":\"348B9227-B6CC-4789-26D5-4BF9E2C6D4AC\"},{\"Name\":\"Abdul\",\"Status\":\"64602AC1-91AC-2B1F-0D9C-1215805535DD\"},{\"Name\":\"Xander\",\"Status\":\"C8C2607C-9415-D829-D4C1-942363D0A665\"},{\"Name\":\"Evan\",\"Status\":\"CFC727D9-7196-6878-788D-C8658471B6BE\"},{\"Name\":\"Leo\",\"Status\":\"1408CAEB-A059-C81C-8B81-336A264AB02C\"},{\"Name\":\"Bruno\",\"Status\":\"94FBE422-ADA2-C4C9-03AD-63ED18E7A367\"}]";
    
    NSError *err;
    
    NSData  *contactsJson = [contactsJsonString dataUsingEncoding:NSUTF8StringEncoding];
    _contacts = [NSJSONSerialization JSONObjectWithData:contactsJson options:NSJSONReadingAllowFragments error:&err];
    
    
    if (err == nil) {
        NSLog(@"Good.");
    }
    else {
        NSLog(@"Bad.");
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier];
    }
    
    NSString *contactName;
    
    int i = 0;
    
    for (id contact in _contacts){
        
        if (i == indexPath.row)
        {
            for (id key in contact) {
                if ([key isEqualToString:@"Name"])
                {
                    contactName = [contact objectForKey:key];
                }
            }
        }
        i++;
    }

    [cell.textLabel setText:contactName];
    
    cell.imageView.image = [UIImage imageNamed:@"contactimg.jpg"];
    cell.imageView.layer.cornerRadius = 30;
    cell.imageView.layer.masksToBounds= YES;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = themeManager.textColor;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:nil cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil];
        
        [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        [actionSheet showInView:self.view];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueContactsChat" sender:tableView];
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
