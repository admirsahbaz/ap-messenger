//
//  ThemeViewController.m
//  APMessenger
//
//  Created by Elma Arslanagic on 2/21/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIColor+FromHex.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController
@synthesize theme1Img;
@synthesize theme2Img;
@synthesize theme3Img;
@synthesize theme4Img;
@synthesize theme5Img;
@synthesize theme6Img;
@synthesize chooseThemeLbl;

ThemeManager *thThemeManager;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    thThemeManager = [ThemeManager SharedInstance];
    
    CAGradientLayer *backroundGradient = [CAGradientLayer layer];
    backroundGradient.frame = self.view.bounds;
    backroundGradient.colors = [NSArray arrayWithObjects:(id)[thThemeManager.backgroundTopColor CGColor], (id)[thThemeManager.backgroundBottomColor CGColor], nil];
    [self.view.layer insertSublayer:backroundGradient atIndex:0];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedImg1)];
    singleTap1.numberOfTapsRequired = 1;
    [theme1Img setUserInteractionEnabled: YES];
    [theme1Img addGestureRecognizer:singleTap1];
    
    UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedImg2)];
    singleTap2.numberOfTapsRequired = 1;
    [theme2Img setUserInteractionEnabled: YES];
    [theme2Img addGestureRecognizer:singleTap2];
    
    theme1Img.layer.cornerRadius = 65;
    theme1Img.layer.borderWidth = 2.0;
    theme1Img.layer.borderColor = [thThemeManager.contactImageBorderColor CGColor];;
    theme1Img.layer.masksToBounds = YES;
    
    NSString *path = [[NSBundle mainBundle] pathForResource: @"default" ofType:@"plist"];
    NSDictionary *theme = [NSDictionary dictionaryWithContentsOfFile:path];
    NSString *backgroundColor = [theme objectForKey:@"backgroundTopColor"];
    
    //replace this with image
    theme1Img.layer.backgroundColor = [[UIColor colorwithHexString:backgroundColor alpha:1] CGColor];
    
    theme2Img.layer.cornerRadius = 65;
    theme2Img.layer.borderWidth = 2.0;
    theme2Img.layer.borderColor = [thThemeManager.contactImageBorderColor CGColor];;
    theme2Img.layer.masksToBounds = YES;
    
    NSString *path2 = [[NSBundle mainBundle] pathForResource: @"gray" ofType:@"plist"];
    NSDictionary *theme2 = [NSDictionary dictionaryWithContentsOfFile:path2];
    NSString *backgroundColor2 = [theme2 objectForKey:@"backgroundTopColor"];
    
    //replace this with image
    theme2Img.layer.backgroundColor = [[UIColor colorwithHexString:backgroundColor2 alpha:1] CGColor];
    
    theme3Img.layer.cornerRadius = 65;
    theme3Img.layer.borderWidth = 2.0;
    theme3Img.layer.borderColor = [thThemeManager.contactImageBorderColor CGColor];;
    theme3Img.layer.masksToBounds = YES;
    
    theme4Img.layer.cornerRadius = 65;
    theme4Img.layer.borderWidth = 2.0;
    theme4Img.layer.borderColor = [thThemeManager.contactImageBorderColor CGColor];;
    theme4Img.layer.masksToBounds = YES;
    
    theme5Img.layer.cornerRadius = 65;
    theme5Img.layer.borderWidth = 2.0;
    theme5Img.layer.borderColor = [thThemeManager.contactImageBorderColor CGColor];;
    theme5Img.layer.masksToBounds = YES;
    
    theme6Img.layer.cornerRadius = 65;
    theme6Img.layer.borderWidth = 2.0;
    theme6Img.layer.borderColor = [thThemeManager.contactImageBorderColor CGColor];;
    theme6Img.layer.masksToBounds = YES;

    chooseThemeLbl.textColor = thThemeManager.textColor;
    
}

-(void)tapDetectedImg1{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[@"default" lowercaseString] forKey:@"theme"];
}

-(void)tapDetectedImg2{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[@"gray" lowercaseString] forKey:@"theme"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end