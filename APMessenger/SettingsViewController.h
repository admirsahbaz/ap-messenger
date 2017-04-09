//
//  SettingsViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/24/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface SettingsViewController: UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate,SDWebImageManagerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *storageConnectionString;

@end
