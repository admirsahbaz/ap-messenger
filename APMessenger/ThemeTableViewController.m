//
//  ThemeTableViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/29/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ThemeTableViewController.h"

@interface ThemeTableViewController ()

@end

@implementation ThemeTableViewController

@synthesize identifier = _identifier;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = self.navigationController.navigationBar.frame;
    float y = rect.size.height + rect.origin.y;
    [[self tableView] setContentInset:UIEdgeInsetsMake(y, 0, 0, 0)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_identifier];
    }
    
    if(indexPath.row == 0)
    {
        UILabel *lblTheme = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 4.0f, 200.0f, 20.0f)];
        
        [lblTheme setText:@"default"];
        [lblTheme setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblTheme.layer.borderWidth = 0.0f;
        lblTheme.tag = 1;
        [cell addSubview:lblTheme];
       
    }
    
    if(indexPath.row == 1)
    {
        UILabel *lblTheme = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 4.0f, 200.0f, 20.0f)];
        
        [lblTheme setText:@"gray"];
        [lblTheme setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblTheme.layer.borderWidth = 0.0f;
        lblTheme.tag = 1;
        [cell addSubview:lblTheme];
        
    }
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = (UITableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    UILabel *customLabel = (UILabel *)[cell viewWithTag:1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:customLabel.text forKey:@"theme"];
    
    NSString *themeName = [defaults objectForKey:@"theme"] ?: @"default";
    
    NSLog(@"Label text: %@   Theme name: %@",customLabel.text, themeName);
 
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
