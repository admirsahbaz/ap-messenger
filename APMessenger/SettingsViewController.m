//
//  SettingsViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/24/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize identifier = _identifier;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.title = @"Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
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
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        UILabel *lblPassword = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 4.0f, 200.0f, 20.0f)];
        
        [lblPassword setText:@"Password"];
        [lblPassword setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblPassword.layer.borderWidth = 0.0f;
        [cell addSubview:lblPassword];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UILabel *lblTheme = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 4.0f, 200.0f, 20.0f)];
        
        [lblTheme setText:@"Theme"];
        [lblTheme setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblTheme.layer.borderWidth = 0.0f;
        [cell addSubview:lblTheme];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"SegueSettingsPassword" sender:tableView];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"SegueSettingsTheme" sender:tableView];
    }
}

-(NSString *)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
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
    return sectionName;
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
