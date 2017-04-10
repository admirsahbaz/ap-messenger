//
//  ContactProfileViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 1/11/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ContactProfileViewController.h"
#import "ThemeManager.h"
#import "RestHelper.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ContactProfileViewController ()

@end

@implementation ContactProfileViewController

@synthesize lblUsername;
@synthesize lblUserEmail;
@synthesize profilePicture;
@synthesize picture;

ThemeManager *_themeManager;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    RestHelper *rest =  [RestHelper SharedInstance];
    
    [rest requestPath:@"/UpdateLastActivity" withData:nil andHttpMethod:@"POST" onCompletion:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    // Do any additional setup after loading the view.
    _themeManager = [ThemeManager SharedInstance];
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
    
    self.profilePicture.image = [self resizeImage:[ UIImage imageNamed:@"DefaultUserIcon"] imageSize:CGSizeMake(150, 150)];
    
    self.picture.image = [self resizeImage:[ UIImage imageNamed:@"DefaultUserIcon"] imageSize:CGSizeMake(300, 300)];
    
    self.picture.layer.cornerRadius = 60;
    self.picture.layer.borderWidth = 2.0;
    self.picture.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.picture.layer.masksToBounds = YES;
    
    //backgorund color
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[_themeManager.backgroundTopColor CGColor], (id)[_themeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    
    //text color
    lblUsername.textColor = _themeManager.textColor;
    lblUserEmail.textColor = _themeManager.textColor;
    
}
-(UIImage *)resizeImage: (UIImage *) image imageSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
