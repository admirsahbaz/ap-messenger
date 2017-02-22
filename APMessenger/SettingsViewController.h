//
//  SettingsViewController.h
//  APMessenger
//
//  Created by Elma Arslanagic on 1/24/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController: UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) IBOutlet UIButton *uploadImageBtn;

- (IBAction)uploadImageBtn:(id)sender;


@end
