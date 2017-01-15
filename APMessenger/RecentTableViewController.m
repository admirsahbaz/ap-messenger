//
//  RecentTableViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "RecentTableViewController.h"

@interface RecentTableViewController ()

@end

@implementation RecentTableViewController

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize recents = _recents;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    CGRect rect = self.navigationController.navigationBar.frame;
    
    float y = rect.size.height + rect.origin.y;
    
    [[self tableView] setContentInset:UIEdgeInsetsMake(y, 0, 0, 0)];
    
    _recents = [[NSMutableDictionary alloc] init];
    
    NSString *json = @"[{\"Name\": \"Hampton, Jillian P.\",\"Address\": \"Ap #272-3319 Mauris St.\",\"Zip\": \"3515\",\"City\": \"Ripabottoni\",\"Country\": \"Honduras\"},{\"Name\": \"Guthrie, Madison L.\",\"Address\": \"127-3041 Ac Rd.\",\"Zip\": \"9841\",\"City\": \"Devizes\",\"Country\": \"El Salvador\"},{\"Name\": \"Knight, Hasad K.\",\"Address\": \"P.O. Box 548, 7082 Vulputate Av.\",\"Zip\": \"6975LI\",\"City\": \"Pirmasens\",\"Country\": \"Trinidad and Tobago\"},{\"Name\": \"Mays, Paul A.\",\"Address\": \"262-3049 Interdum St.\",\"Zip\": \"048348\",\"City\": \"Neuruppin\",\"Country\": \"Qatar\"},{\"Name\": \"Keller, Naida Y.\",\"Address\": \"783-6178 Lectus St.\",\"Zip\": \"207801\",\"City\": \"Hildesheim\",\"Country\": \"Macedonia\"},{\"Name\": \"Stein, Holmes W.\",\"Address\": \"Ap #867-6568 Est. Rd.\",\"Zip\": \"16245\",\"City\": \"Pickering\",\"Country\": \"Congo, the Democratic Republic of the\"},{\"Name\": \"Herman, Jordan P.\",\"Address\": \"Ap #188-6459 Odio Street\",\"Zip\": \"79290\",\"City\": \"Gold Coast\",\"Country\": \"Moldova\"}]";
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    
    _recents = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    
    if (err == nil)
    {
        NSLog(@"Success");
    }
    else
    {
        NSLog(@"Error");
    }
    
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_reuseIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueRecentChat" sender:tableView];
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
