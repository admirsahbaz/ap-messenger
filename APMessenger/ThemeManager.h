//
//  ThemeManager.h
//  APMessenger
//
//  Created by Admir Sahbaz on 1/28/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

+ (ThemeManager *) SharedInstance;

@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *backgroundTopColor;
@property (strong, nonatomic) UIColor *backgroundBottomColor;
@property (strong, nonatomic) UIColor *contactImageBorderColor;
@property (strong, nonatomic) UIColor *tableViewSeparatorColor;
@property (strong, nonatomic) UIColor *navigationBarBackgroundColor;
@property (strong, nonatomic) UIColor *actionButtonLeftColor;
@property (strong, nonatomic) UIColor *actionButtonRightColor;
@end
