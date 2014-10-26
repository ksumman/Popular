//
//  UIColor+Popular.m
//  Popular
//
//  Created by Kumar Summan on 10/25/14.
//  Copyright (c) 2014 Kumar Summan. All rights reserved.
//

#import "UIColor+Popular.h"

@implementation UIColor (Popular)

+(UIColor *) plThemeColor1
{
    UIColor *plThemeColor1 = [UIColor colorWithRed:134.0/255.0
                                             green:31.0/255.0
                                              blue:181.0/255.0
                                             alpha:1.0];
    return plThemeColor1;
}

+(UIColor *) plThemeColor2
{
    UIColor *plThemeColor2 = [UIColor colorWithRed:184.0/255.0
                                             green:131.0/255.0
                                              blue:220.0/255.0
                                             alpha:1.0];
    return plThemeColor2;
}

+(UIColor *) plLightGrayColor
{
    UIColor *plLightGrayColor = [UIColor colorWithRed:194.0/255.0
                                                green:194.0/255.0
                                                 blue:194.0/255.0
                                                alpha:1.0];
    return plLightGrayColor;
}

+(UIColor *) plDarkGrayColor
{
    UIColor *plDarkGrayColor = [UIColor colorWithRed:94.0/255.0
                                               green:94.0/255.0
                                                blue:94.0/255.0
                                               alpha:1.0];
    return plDarkGrayColor;
    
}

@end
