//
//  SettingsViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/24/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "SettingsViewController.h"
#import "ThemeManager.h"
#import "CurrentUser.h"
#import "RecentTableViewController.h"
#import <AZSClient/AZSClient.h>
#import "RestHelper.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize identifier = _identifier;
@synthesize profileImage;


ThemeManager *settingsThemeManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/UpdateLastActivity" withData:nil andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    settingsThemeManager = [ThemeManager SharedInstance];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[settingsThemeManager.backgroundTopColor CGColor], (id)[settingsThemeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    self.profileImage.layer.cornerRadius = 70;
    self.profileImage.layer.borderWidth = 2.0;
    self.profileImage.layer.borderColor = [settingsThemeManager.contactImageBorderColor CGColor];;
    self.profileImage.layer.masksToBounds = YES;
        
    self.profileImage.image = [self resizeImage:[UIImage imageNamed:@"contactimg.jpg"] imageSize:CGSizeMake(150, 150)];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg)];
    singleTap.numberOfTapsRequired = 1;
    [self.profileImage setUserInteractionEnabled: YES];
    [self.profileImage addGestureRecognizer:singleTap];
    
}

-(void)tapImg{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


- (void)viewDidAppear:(BOOL)animated {
    self.tabBarController.title = @"Settings";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    tableView.separatorColor = settingsThemeManager.tableViewSeparatorColor;
    return 2;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        UILabel *lblPassword = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblPassword setText:@"Password"];
        [lblPassword setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblPassword.layer.borderWidth = 0.0f;
        lblPassword.textColor = settingsThemeManager.textColor;
        
        [cell addSubview:lblPassword];
    }
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        UILabel *lblLogout = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblLogout setText:@"Logout"];
        [lblLogout setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblLogout.layer.borderWidth = 0.0f;
        lblLogout.textColor = settingsThemeManager.textColor;
        
        [cell addSubview:lblLogout];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        UILabel *lblTheme = [[UILabel alloc] initWithFrame:CGRectMake(25.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblTheme setText:@"Theme"];
        [lblTheme setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
        lblTheme.layer.borderWidth = 0.0f;
        lblTheme.textColor = settingsThemeManager.textColor;
        
        [cell addSubview:lblTheme];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *selectedTheme = [defaults objectForKey:@"theme"];
        
        UILabel *lblSelectedTheme = [[UILabel alloc] initWithFrame:CGRectMake(140.0f, 10.0f, 200.0f, 20.0f)];
        
        [lblSelectedTheme setText:selectedTheme];
        [lblSelectedTheme setFont:[UIFont systemFontOfSize: 14.0f weight: normal]];
        lblSelectedTheme.layer.borderWidth = 0.0f;
        lblSelectedTheme.textColor = settingsThemeManager.textColor;
        [lblSelectedTheme setTextAlignment:NSTextAlignmentRight];
        
        [cell addSubview:lblSelectedTheme];
    }
    
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"SegueSettingsPassword" sender:tableView];
    }
    
    if(indexPath.section == 0 && indexPath.row == 1)
    {
        CurrentUser *user = [CurrentUser Current];
        [user LogOutUser];
        [RecentTableViewController cancelTimer];
        [self performSegueWithIdentifier:@"SegueSettingsLogout" sender:tableView];
    }
    
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"SegueSettingsTheme" sender:tableView];
    }
}


-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
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
    UIView *viewHeader = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.frame.size.width, 40.0f)];
    UILabel *lblSection = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 320.0f, 40.0f)];
    
    [lblSection setText:sectionName];
    [lblSection setFont:[UIFont systemFontOfSize: 13.0f weight: 600.0f]];
    [lblSection setTextAlignment:NSTextAlignmentLeft];
    lblSection.layer.borderWidth = 0.0f;
    lblSection.textColor = settingsThemeManager.textColor;
    
    [viewHeader addSubview:lblSection];
    
    viewHeader.backgroundColor = [UIColor colorWithWhite:0.8f alpha:0.2f];
    
    return viewHeader;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    profileImage.image = [self resizeImage:image imageSize:CGSizeMake(150, 150)];
   
}

-(UIImage *)resizeImage: (UIImage *) image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
