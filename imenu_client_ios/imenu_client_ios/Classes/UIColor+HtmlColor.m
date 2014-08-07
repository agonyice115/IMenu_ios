//
//  UIColor+HtmlColor.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-4.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "UIColor+HtmlColor.h"

@implementation UIColor (HtmlColor)

+ (UIColor *)colorWithHtmlColor:(NSString *)colorString
{
    if ([colorString length] != 7 || ![colorString hasPrefix:@"#"])
    {
        return [UIColor blackColor];
    }
    
    NSRange range;
    range.location = 1;
    range.length = 2;
    
    NSString *rString = [colorString substringWithRange:range];
    range.location += 2;
    NSString *gString = [colorString substringWithRange:range];
    range.location += 2;
    NSString *bString = [colorString substringWithRange:range];
    
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
}

@end
