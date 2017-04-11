//
//  ContactTableViewCell.m
//  APMessenger
//
//  Created by Admir Sahbaz on 2/5/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ContactTableViewCell.h"
#import "ThemeManager.h"

@implementation ContactTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    ThemeManager *themeManager = [ThemeManager SharedInstance];
    
    self.ContactImage.layer.cornerRadius = 30;
    self.ContactImage.layer.masksToBounds = YES;
    self.ContactImage.layer.borderColor = [themeManager.contactImageBorderColor CGColor];
    self.ContactImage.layer.borderWidth = 3.5;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, self.bounds.size.width, 1)];
    bottomLineView.backgroundColor = themeManager.tableViewSeparatorColor;
    [self.contentView addSubview:bottomLineView];
    
    // Configure the view for the selected state
}

@end
