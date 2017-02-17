//
//  SettingsViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/24/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeManager.h"
#import "CurrentUser.h"
#import "RecentTableViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize identifier = _identifier;

ThemeManager *settingsThemeManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    settingsThemeManager = [ThemeManager SharedInstance];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[settingsThemeManager.backgroundTopColor CGColor], (id)[settingsThemeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
}

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.title = @"Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.separatorColor = settingsThemeManager.tableViewSeparatorColor;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        UILabel *lblPassword = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblPassword setText:@"Password"];
        [lblPassword setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblPassword.layer.borderWidth = 0.0f;
        lblPassword.textColor = settingsThemeManager.textColor;
        
        [cell addSubview:lblPassword];
    }
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        UILabel *lblLogout = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblLogout setText:@"Logout"];
        [lblLogout setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblLogout.layer.borderWidth = 0.0f;
        lblLogout.textColor = settingsThemeManager.textColor;
        
        [cell addSubview:lblLogout];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UILabel *lblTheme = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblTheme setText:@"Theme"];
        [lblTheme setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblTheme.layer.borderWidth = 0.0f;
        lblTheme.textColor = settingsThemeManager.textColor;
        
        [cell addSubview:lblTheme];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *selectedTheme = [defaults objectForKey:@"theme"];
        
        UILabel *lblSelectedTheme = [[UILabel alloc] initWithFrame:CGRectMake(140.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblSelectedTheme setText:[selectedTheme uppercaseString]];
        [lblSelectedTheme setFont:[UIFont systemFontOfSize: 14.0f weight: normal]];
        lblSelectedTheme.layer.borderWidth = 0.0f;
        lblSelectedTheme.textColor = settingsThemeManager.textColor;
        [lblSelectedTheme setTextAlignment:NSTextAlignmentRight];
        
        [cell addSubview:lblSelectedTheme];
    }
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"SegueSettingsPassword" sender:tableView];
    }
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        CurrentUser *user = [CurrentUser Current];
        [user LogOutUser];
        [RecentTableViewController cancelTimer];
        [self performSegueWithIdentifier:@"SegueSettingsLogout" sender:tableView];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"SegueSettingsTheme" sender:tableView];
    }
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = @"User profile";
            break;
        case 1:
            sectionName = @"Preferences";
            break;
        default:
            sectionName = @"";
            break;
    }
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 40.0f)];
    UILabel *lblSection = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 320.0f, 40.0f)];
    
    [lblSection setText:sectionName];
    [lblSection setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
    [lblSection setTextAlignment:NSTextAlignmentLeft];
    lblSection.layer.borderWidth = 0.0f;
    lblSection.textColor = settingsThemeManager.textColor;
    
    [viewHeader addSubview:lblSection];
    
    viewHeader.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.2f];
    
    return viewHeader;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
