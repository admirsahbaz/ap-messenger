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
#import "RestHelper.h"
#import "ChatViewController.h"
#import "ContactTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ContactProfileViewController.h"

@interface ContactsViewController ()
@end

@implementation ContactsViewController

@synthesize contacts = _contacts;
@synthesize identifier = _identifier;

ThemeManager *themeManager;
NSInteger *selectedContact;
NSIndexPath *cellIndexPath;
UIStoryboardSegue *segue;

- (NSArray *)rightButtons
{
    themeManager = [ThemeManager SharedInstance];
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     themeManager.tableViewSeparatorColor
                                                 icon:[UIImage imageNamed:@"icon-profile"]];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     themeManager.tableViewSeparatorColor
                                                 icon:[UIImage imageNamed:@"icon-thrash"]];
    
    return rightUtilityButtons;
}

-(void)addContactsAction{
    [self performSegueWithIdentifier:@"SegueContactsSearchPeople" sender:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    RestHelper *rest =  [RestHelper SharedInstance];

    [rest requestPath:@"/UpdateLastActivity" withData:nil andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    
    themeManager = [ThemeManager SharedInstance];
    
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[themeManager.backgroundTopColor CGColor], (id)[themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    CAGradientLayer *btnGradient = [CAGradientLayer layer];
    btnGradient.frame = self.addContacts.layer.bounds;
    btnGradient.colors = [NSArray arrayWithObjects:(id)[themeManager.actionButtonLeftColor CGColor], (id)[themeManager.actionButtonRightColor CGColor], nil];
    btnGradient.startPoint = CGPointMake(0.0, 0.5);
    btnGradient.endPoint = CGPointMake(1.0, 0.5);
    btnGradient.cornerRadius = 8;
    [self.addContacts.layer addSublayer:btnGradient];
    self.addContacts.layer.cornerRadius = 8;
    self.addContacts.tintColor = themeManager.textColor;
    [self.addContacts addTarget:self action:@selector(addContactsAction) forControlEvents:UIControlEventTouchUpInside];
    // Do any additional setup after loading the view.
}

- (void) getContacts {
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/Contacts" withData:nil andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillTable:data withError:error];
        });
    }];
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
        _contacts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
        
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

- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.title = @"Contacts";
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self getContacts];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.separatorColor = themeManager.tableViewSeparatorColor;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contacts count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactTableViewCell *cell = (ContactTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"contactTableViewCell"];
    
    cell.rightUtilityButtons = [self rightButtons];
    cell.delegate = self;
    
    NSString *contactName;
    NSString *imgUrl;
    NSLocale *currentLocale = [NSLocale currentLocale];
    [[NSDate date ] descriptionWithLocale:currentLocale];
    NSInteger currentTimeInterval = [[NSDate date] timeIntervalSince1970];
    NSDate *lastActivity;
    
    id row = [_contacts objectAtIndex:indexPath.row];
    contactName = [row objectForKey:@"Name"];
    imgUrl = [row objectForKey:@"ImageUrl"];
    
       NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
      [dateFormater setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss.SS"];
    lastActivity = [dateFormater dateFromString:[row objectForKey:@"LastActivity"]];
    
    NSInteger userLastActivity = [ lastActivity timeIntervalSince1970];
   
      if((currentTimeInterval - userLastActivity) > 60){
           [cell.Status setImage:[UIImage imageNamed:@"status-offline"]];
         }
     else
          {
               [cell.Status setImage:[UIImage imageNamed:@"status-online"]];
          }
    cell.ContactName.text = contactName;
    cell.ContactName.textColor = themeManager.textColor;
    cell.ContactImage.image = [UIImage imageNamed:@"DefaultUserIcon"];    
   
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imgUrl]
                          options:SDWebImageRefreshCached
                         progress:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            if(image != nil)
                            {
                                cell.ContactImage.image= [self resizeImage:image imageSize:CGSizeMake(150, 150)];
                            }
                        }];
    
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


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            id row = [_contacts objectAtIndex:cellIndexPath.row];
            [self performSegueWithIdentifier:@"SegueContactsContact" sender:row];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            cellIndexPath = [self.tableView indexPathForCell:cell];
            id row = [_contacts objectAtIndex:cellIndexPath.row];
            selectedContact = [[row objectForKey:@"Id"] integerValue];
            
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:self cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil];
            
            [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionSheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self deleteContact];
            break;
        default:
            break;
    }
}

- (void) deleteContact {
    RestHelper *rest =  [RestHelper SharedInstance];
    
    NSString *requestUrl = @"/Contacts/";
    
    [rest requestPath:[NSString stringWithFormat:@"/Contacts/%i", selectedContact] withData:nil andHttpMethod:@"DELETE" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err = nil;
            if(data){
                NSString *str = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                if (err == nil && [str isEqualToString:@"true"])
                {
                    [_contacts removeObjectAtIndex:cellIndexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                else
                {
                    NSLog(@"Error");
                }
                
            }
        });
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id row = [_contacts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SegueContactsChat" sender:row];
}

#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"SegueContactsChat"])
    {
        NSString *userId =[sender objectForKey:@"Id"];

        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"Id", nil];
        
        RestHelper *rest =  [RestHelper SharedInstance];

        [rest requestPath:@"/GetContactChat" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error)
                {
                    NSLog(@"ERROR : %@", error);
                }
                else{
                    
                    ChatViewController *cvc = [segue destinationViewController];
                    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                    NSString * chatId =[dictResponse objectForKey:@"ChatId"];
                    cvc.chatId = [chatId integerValue];
                    cvc.chatPerson = [sender objectForKey:@"Name"];
                }
            });
        }];

    }
    else if ([[segue identifier] isEqualToString:@"SegueContactsContact"]){
       
        NSString *userId =[sender objectForKey:@"Id"];
       
        RestHelper *rest =  [RestHelper SharedInstance];
        self.segue = segue;
        
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"Id", nil];
        
        [rest requestPath:@"/GetUserDetails" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(error)
                {
                    NSLog(@"ERROR : %@", error);
                }
                else{
                    NSError *err = nil;
                    if(!data){
                        return;
                    }
                    if (err == nil)
                    {
                        NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                        ContactProfileViewController *profilectrl = [segue destinationViewController];

                        [profilectrl.lblUserEmail setText:[dictResponse objectForKey:@"Name"]];
                        [profilectrl.lblUsername setText:[dictResponse objectForKey:@"Email"]];
                        NSString * pictureUrl = [dictResponse objectForKey:@"PictureUrl"];
                        
                        SDWebImageManager *manager = [SDWebImageManager sharedManager];
                        [manager downloadImageWithURL:[NSURL URLWithString:pictureUrl]
                                              options:SDWebImageRefreshCached
                                             progress:nil
                                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                if(image != nil)
                                                {
                                                    profilectrl.profilePicture.image = [self resizeImage:image imageSize:CGSizeMake(150, 150)];
                                                    profilectrl.picture.image = [self resizeImage:image imageSize:CGSizeMake(300, 300)];
                                                }
                                            }];
                        
                        NSLog(@"Success");
                    }
                    else
                    {
                        NSLog(@"Error");
                    }
                }
            });
        }];
    }
}

@end
