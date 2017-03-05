//
//  SearchPeopleTableViewController.m
//  APMessenger
//
//  Created by Admir Sahbaz on 2/25/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "SearchPeopleTableViewController.h"
#import "ThemeManager.h"
#import "RestHelper.h"
#import "SearchPeopleTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+FromColor.h"

@interface SearchPeopleTableViewController ()

@end

@implementation SearchPeopleTableViewController

@synthesize people = _people;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ThemeManager *themeManager = [ThemeManager SharedInstance];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[themeManager.backgroundTopColor CGColor], (id)[themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    self.tableView.separatorColor = themeManager.tableViewSeparatorColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.delegate = self;
    self.searchController.searchBar.barTintColor = themeManager.backgroundTopColor;
    self.searchController.searchBar.tintColor = [UIColor whiteColor];
    self.searchController.searchBar.delegate = self;
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.definesPresentationContext = YES;
    [self.searchController.searchBar sizeToFit];
    
    self.tableView.backgroundColor = (id)themeManager.backgroundTopColor;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)fillTable:(NSData*)data withError:(NSError*)error{
    if(error)
    {
        NSLog(@"ERROR: %@", error);
    }
    else{
        NSError *err = nil;
        if(!data){
            return;
        }
        
        _people = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
        if (err == nil)
        {
            NSLog(@"Success");
        }
        else
        {
            NSLog(@"Error");
        }
        [self.tableView reloadData];
    }
}

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    RestHelper *rest =  [RestHelper SharedInstance];

    NSString *requestUrl = @"/Contacts/Search/";
    NSString *requestParams = self.searchController.searchBar.text;
    
    if(![requestParams isEqualToString:@""] && [requestParams length] > 2){
        [rest requestPath:[requestUrl stringByAppendingString:requestParams] withData:nil andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self fillTable:data withError:error];
            });
        }];
    }else if([requestParams length] <= 2)
        _people = nil;
        [self.tableView reloadData];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [_people count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ThemeManager *themeManager = [ThemeManager SharedInstance];
    
    SearchPeopleTableViewCell *cell = (SearchPeopleTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"searchPeopleTableViewCell"];
    
    // Configure the cell...
    NSString *contactName;
    NSString *imgUrl;
    
    id row = [_people objectAtIndex:indexPath.row];
    contactName = [row objectForKey:@"Name"];
    imgUrl = [row objectForKey:@"ImageUrl"];
    
    cell.name.text = contactName;
    cell.name.textColor = themeManager.textColor;
    
    [cell.image sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserIcon"]];
    
    cell.image.layer.cornerRadius = 30;
    cell.image.layer.masksToBounds = YES;
    cell.image.layer.borderColor = [themeManager.contactImageBorderColor CGColor];
    cell.image.layer.borderWidth = 3.5;
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 1)];
    bottomLineView.backgroundColor = themeManager.tableViewSeparatorColor;
    [cell.contentView addSubview:bottomLineView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueSearchPeopleContact" sender:tableView];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
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
