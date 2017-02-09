//
//  RecentTableViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "RecentTableViewController.h"
#import "RestHelper.h"
#import "ChatViewController.h"

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
    self.tableView.backgroundColor = [UIColor colorWithRed:71.0f/255 green:146.0f/255 blue:162.0f/255 alpha:1];
    CGRect rect = self.navigationController.navigationBar.frame;
    
    float y = rect.size.height + rect.origin.y;
    
    [[self tableView] setContentInset:UIEdgeInsetsMake(y, 0, 0, 0)];
    
    _recents = [[NSMutableArray alloc] init];
    
    //[loadingSpinner startAnimating];
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/GetRecents" withData:nil andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillRecentsTable:data withError:error];
        });
    }];

    
   //NSString *json = @"[{\"Name\": \"Hampton, Jillian P.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Guthrie, Madison L.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Knight, Hasad K.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Mays, Paul A.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Keller, Naida Y.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Stein, Holmes W.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Herman, Jordan P.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"}]";
    
    //NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    //NSError *err;
    
    //_recents = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&err];
    
    //if (err == nil)
    //{
     //   NSLog(@"Success");
    //}
    //else
    //{
    //    NSLog(@"Error");
    //}
    
}

- (void)fillRecentsTable:(NSData*)data withError:(NSError*)error{
    if(error)
    {
        NSLog(@"ERROR: %@", error);
    }
    else{
        NSError *err = nil;
        if(!data){
            return;
        }
        _recents = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err == nil)
        {
            NSLog(@"Success");
        }
        else
        {
            NSLog(@"Error");
        }
        [self.tableView reloadData];
        //[messageLabel setHidden:NO];
        //[messageLabel setText:@"Registration Completed"];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.title = @"Recent";
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
    return _recents.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_reuseIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:_reuseIdentifier];
    }
    
    
    NSString *sName;
    NSString *sLastMessage;
    
    id row = [_recents objectAtIndex:indexPath.row];
    sName = [row objectForKey:@"Name"];
    sLastMessage = [row objectForKey:@"LastMessage"];
    
    
    UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 4.0f, 200.0f, 20.0f)];
    
    [lblName setText:sName];
    [lblName setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
    [lblName setTextColor:[UIColor whiteColor]];
    lblName.layer.borderWidth = 0.0f;
    [cell addSubview:lblName];
    
    UILabel *lblLastMessage = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 24.0f, 200.0f, 20.0f)];
    
    [lblLastMessage setText:[[NSString alloc] initWithFormat:@"%@", sLastMessage]];
    [lblLastMessage setFont:[UIFont systemFontOfSize: 10.0f]];
    [lblLastMessage setTextColor:[UIColor whiteColor]];
    lblLastMessage.layer.borderWidth = 0.0f;
    [cell addSubview:lblLastMessage];
    cell.backgroundColor = [UIColor colorWithRed:71.0f/255 green:146.0f/255 blue:162.0f/255 alpha:1];

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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([[segue identifier] isEqualToString:@"SegueRecentChat"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        ChatViewController *cvc = [segue destinationViewController];
        id row = [_recents objectAtIndex:indexPath.row];
        NSString *chatId = [row objectForKey:@"ChatId"];
        cvc.chatId = [chatId integerValue];
        cvc.chatPerson = [row objectForKey:@"Name"];
    }
}


@end
