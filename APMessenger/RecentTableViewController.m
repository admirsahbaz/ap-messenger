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
#import "ThemeManager.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface RecentTableViewController ()

@end

dispatch_source_t timerRecents;
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
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];

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
    
    _recents = [[NSMutableArray alloc] init];
    
    //[loadingSpinner startAnimating];
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/GetRecents" withData:nil andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillRecentsTable:data withError:error];
        });
    }];
    
    [rest requestPath:@"/UpdateLastActivity" withData:nil andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    timerRecents = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timerRecents, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0.5 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timerRecents, ^{
        [self refreshRecents];
    });
    dispatch_resume(timerRecents);
    
}

- (void)refreshRecents{
    NSLog(@"Recents refresh");
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/GetRecents" withData:nil andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillRecentsTable:data withError:error];
        });
    }];
}

+(void)cancelTimer{
    dispatch_source_cancel(timerRecents);
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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete){
        id row = [_recents objectAtIndex:indexPath.row];
        NSString *chatId = [row objectForKey:@"ChatId"];
        RestHelper *rest =  [RestHelper SharedInstance];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete chat" message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:chatId, @"ChatId", nil];

            [rest requestPath:@"/DeleteChat" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleError:data withError:error];
                });
            }];
          [self refreshRecents];
        }];
        
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [alert addAction:yes];
        [alert addAction:no];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
 }
- (void)handleError:(NSData*)data withError:(NSError*)error{
    if(error)
    {
        NSLog(@"ERROR 1: %@", error);
    }
    else{
        NSError *err = nil;
        if(!data){
            return;
        }
        
        if (err == nil)
        {
            NSLog(@"Success");
        }
        else
        {
            NSLog(@"Error");
        }
    }
 }

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
    NSString *imgUrl;
    
    id row = [_recents objectAtIndex:indexPath.row];
    sName = [row objectForKey:@"Name"];
    sLastMessage = [row objectForKey:@"LastMessage"];
    imgUrl = [row objectForKey:@"ImageUrl"];
    
    
    cell.textLabel.text = sName;
    cell.textLabel.textColor = recentThemeManager.textColor;
    
    cell.detailTextLabel.text = sLastMessage;
    cell.detailTextLabel.textColor = recentThemeManager.textColor;
    //cell.imageView. = CGSizeMake(60, 70);
  
    cell.imageView.image = [self resizeImage:[UIImage imageNamed:@"DefaultUserIcon"] imageSize:CGSizeMake(60, 60)];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl]
                          options:SDWebImageRefreshCached
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if(image != nil)
                            {
                                cell.imageView.image= [self resizeImage:image imageSize:CGSizeMake(60, 60)];
                            }
                        }];
    
    
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

-(UIImage *)resizeImage: (UIImage *) image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
