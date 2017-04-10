//
//  SearchPeopleTableViewCell.h
//  APMessenger
//
//  Created by Admir Sahbaz on 3/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@interface SearchPeopleTableViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
