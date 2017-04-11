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

static ThemeManager *sharedInstance = nil;
static dispatch_once_t onceToken = 0;

+(ThemeManager *) SharedInstance{
    dispatch_once (&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+(void)setSharedInstance:(ThemeManager *)instance {
    onceToken = 0; // resets the once_token so dispatch_once will run again
    sharedInstance = instance;
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
        self.tableViewSeparatorColor = [UIColor colorwithHexString:tableViewSeparatorColorString alpha:0.7];
        
        // Navigation Bar Background Color
        NSString *navigationBarBackgroundColorString = [theme objectForKey:@"navigationBarBackgroundColor"];
        self.navigationBarBackgroundColor = [UIColor colorwithHexString:navigationBarBackgroundColorString alpha:0.1];
        
        // Text Color
        NSString *textColorHexString = [theme objectForKey:@"textColor"];
        self.textColor = [UIColor colorwithHexString:textColorHexString alpha:0.7];
        
        // Action Button Left Color
        NSString *actionButtonLeftColorHexString = [theme objectForKey:@"actionButtonLeftColor"];
        self.actionButtonLeftColor = [UIColor colorwithHexString:actionButtonLeftColorHexString alpha:1];
    
        // Action Button Right Color
        NSString *actionButtonRightColorHexString = [theme objectForKey:@"actionButtonRightColor"];
        self.actionButtonRightColor = [UIColor colorwithHexString:actionButtonRightColorHexString alpha:1];
    }
    return self;
}

@end
