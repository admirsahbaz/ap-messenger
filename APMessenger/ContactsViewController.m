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
    
    [self getContacts];
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
        _contacts = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        
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
    
    [cell.ContactImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"DefaultUserIcon"]];
    
    cell.ContactImage.layer.cornerRadius = 30;
    cell.ContactImage.layer.masksToBounds = YES;
    cell.ContactImage.layer.borderColor = [themeManager.contactImageBorderColor CGColor];
    cell.ContactImage.layer.borderWidth = 3.5;
    
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.view.bounds.size.width, 1)];
    bottomLineView.backgroundColor = themeManager.tableViewSeparatorColor;
    [cell.contentView addSubview:bottomLineView];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [self performSegueWithIdentifier:@"SegueContactsContact" sender:self.tableView];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
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

- (void) deleteContact{
    RestHelper *rest =  [RestHelper SharedInstance];
    
    NSString *requestUrl = @"/Contacts/";
    
    [rest requestPath:[NSString stringWithFormat:@"/Contacts/%i", selectedContact] withData:nil andHttpMethod:@"DELETE" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self getContacts];
        });
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"SegueContactsChat" sender:tableView];
}


#pragma mark - Navigation

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([[segue identifier] isEqualToString:@"SegueContactsChat"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id _selectedContact = [_contacts objectAtIndex:indexPath.row];
        ChatViewController *cvc = [segue destinationViewController];
        cvc.chatId = 8;
        cvc.chatPerson = [_selectedContact objectForKey:@"Name"];
    }
    else if ([[segue identifier] isEqualToString:@"SegueContactsContact"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id _selectedContact = [_contacts objectAtIndex:indexPath.row];
        NSString *userId =[_selectedContact objectForKey:@"Id"];
        
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
