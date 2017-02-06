//
//  ContactTableViewCell.h
//  APMessenger
//
//  Created by Admir Sahbaz on 2/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ContactImage;
@property (weak, nonatomic) IBOutlet UILabel *ContactName;

@end
