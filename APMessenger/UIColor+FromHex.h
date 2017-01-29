//
//  UIColor+FromHex.h
//  APMessenger
//
//  Created by Admir Sahbaz on 1/29/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (FromHex)
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
@end
