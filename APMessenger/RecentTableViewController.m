//
//  RecentTableViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "RecentTableViewController.h"
#import "ThemeManager.h"

@interface RecentTableViewController ()

@end

@implementation RecentTableViewController

@synthesize reuseIdentifier = _reuseIdentifier;
@synthesize recents = _recents;
ThemeManager *recentThemeManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    recentThemeManager = [ThemeManager SharedInstance];

    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[recentThemeManager.backgroundTopColor CGColor], (id)[recentThemeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.backgroundColor = (id)recentThemeManager.backgroundTopColor;
    //
    CGRect rect = self.navigationController.navigationBar.frame;
    
    float y = rect.size.height + rect.origin.y;
    
    [[self tableView] setContentInset:UIEdgeInsetsMake(y, 0, 0, 0)];
    
    _recents = [[NSMutableDictionary alloc] init];
    
    NSString *json = @"[{\"Name\": \"Hampton, Jillian P.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Guthrie, Madison L.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Knight, Hasad K.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Mays, Paul A.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Keller, Naida Y.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Stein, Holmes W.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"},{\"Name\": \"Herman, Jordan P.\",\"LastMessage\": \"Lorem ipsum dolor sit amet, neque a qui molestiae dapibus nunc augue. Ipsum ut habitant volutpat commodo volutpat nec, sodales id odio, proin sit ut auctor eu vivamus felis, ultrices nunc ac donec.\"}]";
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:_reuseIdentifier];
    }
    
    
    NSString *sName;
    NSString *sLastMessage;
    
    int i = 0;
    
    for (id row in _recents){
        
        if (i == indexPath.row)
        {
            for (id key in row) {
                if ([key isEqualToString:@"Name"])
                {
                    sName = [row objectForKey:key];
                }
                if ([key isEqualToString:@"LastMessage"])
                {
                    sLastMessage = [row objectForKey:key];
                }
                
            }
            
        }
        i++;
    }
    
    cell.textLabel.text = sName;
    cell.textLabel.textColor = recentThemeManager.textColor;
    
    cell.detailTextLabel.text = sLastMessage;
    cell.detailTextLabel.textColor = recentThemeManager.textColor;
    //cell.imageView. = CGSizeMake(60, 70);
    
    cell.imageView.image = [RecentTableViewController scale:[UIImage imageNamed:@"contactimg.jpg"] toSize:CGSizeMake(60, 60)];
    cell.imageView.layer.cornerRadius = 30;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderColor = [recentThemeManager.contactImageBorderColor CGColor];
    cell.imageView.layer.borderWidth = 4;
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70, self.view.bounds.size.width, 1)];
    bottomLineView.backgroundColor = recentThemeManager.tableViewSeparatorColor;
    [cell.contentView addSubview:bottomLineView];
    
    cell.backgroundColor = [UIColor clearColor];
    
    /*UILabel *lblName = [[UILabel alloc] initWithFrame:CGRectMake(15.0f, 4.0f, 200.0f, 20.0f)];
    
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
    cell.backgroundColor = [UIColor colorWithRed:71.0f/255 green:146.0f/255 blue:162.0f/255 alpha:1];*/

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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

+ (UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
