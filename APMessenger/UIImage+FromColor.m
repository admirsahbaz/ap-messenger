//
//  UIImage+FromColor.m
//  APMessenger
//
//  Created by Admir Sahbaz on 2/6/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import "UIImage+FromColor.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (FromColor)
+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
