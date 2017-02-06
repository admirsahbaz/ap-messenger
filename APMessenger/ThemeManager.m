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



+(ThemeManager *) SharedInstance{
    static ThemeManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once (&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
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
        
        // Contact Image Border Color
        NSString *contactImageBorderColorString = [theme objectForKey:@"contactImageBorderColor"];
        self.contactImageBorderColor = [UIColor colorwithHexString:contactImageBorderColorString alpha:0.7];
        
        // TableView Separator Color
        NSString *tableViewSeparatorColorString = [theme objectForKey:@"tableViewSeparatorColor"];
        self.tableViewSeparatorColor = [UIColor colorwithHexString:tableViewSeparatorColorString alpha:0.1];
        
        // Navigation Bar Background Color
        NSString *navigationBarBackgroundColorString = [theme objectForKey:@"navigationBarBackgroundColor"];
        self.navigationBarBackgroundColor = [UIColor colorwithHexString:navigationBarBackgroundColorString alpha:0.1];
        
        // Text Color
        NSString *textColorHexString = [theme objectForKey:@"textColor"];
        self.textColor = [UIColor colorwithHexString:textColorHexString alpha:0.7];
    }
    return self;
}

@end
