//
//  ThemeManager.m
//  APMessenger
//
//  Created by Admir Sahbaz on 1/28/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#import "UIColor+FromHex.h"

@implementation ThemeManager

+ (ThemeManager *)themeManager
{
    static ThemeManager *themeManager = nil;
    if (themeManager == nil)
    {
        themeManager = [[ThemeManager alloc] init];
    }
    return themeManager;
}

- (id)init
{
    if((self = [super init]))
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *themeName = [defaults objectForKey:@"theme"] ?: @"default";
                               
        NSString *path = [[NSBundle mainBundle] pathForResource: themeName ofType:@"plist"];
        NSDictionary *theme = [NSDictionary dictionaryWithContentsOfFile:path];
        
        // Backround Top Color
        NSString *backroundTopColorHexString = [theme objectForKey:@"backgroundTopColor"];
        self.backgroundTopColor = [UIColor colorwithHexString:backroundTopColorHexString alpha:1];
        
        // Backround Bottom Color
        NSString *backroundBottomColorHexString = [theme objectForKey:@"backgroundBottomColor"];
        self.backgroundBottomColor = [UIColor colorwithHexString:backroundBottomColorHexString alpha:1];

        // Primary Color
        NSString *textColorHexString = [theme objectForKey:@"textColor"];
        self.textColor = [UIColor colorwithHexString:textColorHexString alpha:0.7];
    }
    return self;
}

@end
