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
int chatIdTemp;


ThemeManager *themeManager;

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
    
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/Contacts/5" withData:nil andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self fillTable:data withError:error];
        });
    }];
    
    // Do any additional setup after loading the view.
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
    
    id row = [_contacts objectAtIndex:indexPath.row];
    contactName = [row objectForKey:@"Name"];
    imgUrl = [row objectForKey:@"ImageUrl"];
    
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
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Are you sure?" delegate:nil cancelButtonTitle:@"No" destructiveButtonTitle:@"Yes" otherButtonTitles:nil, nil];
            
            [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
            [actionSheet showInView:self.view];
            break;
        }
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      id selectedContact = [_contacts objectAtIndex:indexPath.row];
    NSString *contactId = [selectedContact objectForKey:@"Id"];
    RestHelper *rest =  [RestHelper SharedInstance];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:contactId, @"Id", nil];
    
    [rest requestPath:@"/GetContactChat" withData:dict andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self openChatWindow:data withError:error];
        });
    }];

    
    //[self performSegueWithIdentifier:@"SegueContactsChat" sender:tableView];
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
        cvc.chatId = chatIdTemp;
        cvc.chatPerson = [_selectedContact objectForKey:@"Name"];
    }
    else if ([[segue identifier] isEqualToString:@"SegueContactsContact"]){

        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        id _selectedContact = [_contacts objectAtIndex:indexPath.row];
        NSString *userId =[_selectedContact objectForKey:@"Id"];

        /*RestHelper *rest =  [RestHelper SharedInstance];
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:userId, @"Id", nil];
        [rest requestPath:@"/GetUserDetails" withData:dict andHttpMethod:@"GET" onCompletion:^(NSData *data, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleResponse:data withError:error seque:segue];
               
            });
        }];*/
    }
}
- (void)handleResponse:(NSData*)data withError:(NSError*)error seque: (UIStoryboardSegue *)seque{
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
            ContactProfileViewController *profilectrl = [seque destinationViewController];
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            profilectrl.lblUsername.text = [dictResponse objectForKey:@"Name"];
            profilectrl.lblUserEmail.text= [dictResponse objectForKey:@"Email"];
            NSLog(@"Success");
        }
        else
        {
            NSLog(@"Error");
        }
    }
}



- (void)openChatWindow:(NSData*)data withError:(NSError*)error{
    NSString *chatIdS = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    chatIdTemp = [chatIdS intValue];
    
    [self performSegueWithIdentifier:@"SegueContactsChat" sender:self];
}

@end
