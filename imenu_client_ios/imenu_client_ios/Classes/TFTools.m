//
//  TFTools.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "TFTools.h"
#import <CommonCrypto/CommonDigest.h>

@implementation TFTools

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]];
}

+ (BOOL)validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+ (UIImage *)reSizeImage:(UIImage *)image withSize:(CGSize)size
{
    UIGraphicsBeginImageContext(CGSizeMake(size.width*2, size.height*2));
    [image drawInRect:CGRectMake(0, 0, size.width*2, size.height*2)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reSizeImage;
}

+ (UIImage *)clippingImage:(UIImage *)image withSize:(CGSize)size
{
    CGImageRef imageRef = [image CGImage];
    CGSize imageSize = image.size;
    CGFloat zoom;
    CGRect rect;
    if (size.width/size.height >= imageSize.width/imageSize.height)
    {
        zoom = imageSize.width/size.width;
        if (image.imageOrientation > 1)
        {
            rect = CGRectMake((imageSize.height - zoom*size.height)/2, 0, imageSize.width, zoom*size.height);
        }
        else
        {
            rect = CGRectMake(0, (imageSize.height - zoom*size.height)/2, imageSize.width, zoom*size.height);
        }
    }
    else
    {
        zoom = imageSize.height/size.height;
        if (image.imageOrientation > 1)
        {
            rect = CGRectMake(0, (imageSize.width - zoom*size.width)/2, zoom*size.width, imageSize.height);
        }
        else
        {
            rect = CGRectMake((imageSize.width - zoom*size.width)/2, 0, zoom*size.width, imageSize.height);
        }
    }
    
    CGImageRef cgImg = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *returnImage = [UIImage imageWithCGImage:cgImg scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(cgImg);
    
    return [TFTools reSizeImage:returnImage withSize:size];
}

+ (NSString *)getDocumentPathOfFile:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths.lastObject stringByAppendingPathComponent:fileName];
}

+ (NSString *)getThumbImageUrlOfLacation:(NSString *)location andName:(NSString *)name
{
    if (location == nil || [location length] == 0)
    {
        return nil;
    }
    
    if (name == nil || [name length] == 0)
    {
        return nil;
    }
    
    NSString *image = [name stringByDeletingPathExtension];
    NSString *ext = [name pathExtension];
    return [NSString stringWithFormat:@"%@thumb/%@_thumb.%@", location, image, ext];
}

+ (NSString *)getDistaceString:(NSString *)distance
{
    int distanceValue = distance.integerValue;
    if (distanceValue < 1000)
    {
        return [NSString stringWithFormat:@"%dm", distanceValue/10*10];
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fkm", distanceValue/1000.0f];
    }
    
    if (distanceValue < 50)
    {
        return @"小于50米";
    }
    else if (distanceValue < 100)
    {
        return @"小于100米";
    }
    else if (distanceValue < 200)
    {
        return @"小于200米";
    }
    else if (distanceValue < 300)
    {
        return @"小于300米";
    }
    else if (distanceValue < 500)
    {
        return @"小于500米";
    }
    else if (distanceValue < 1000)
    {
        return @"小于1千米";
    }
    else if (distanceValue < 2000)
    {
        return @"小于2千米";
    }
    else if (distanceValue < 3000)
    {
        return @"小于3千米";
    }
    else if (distanceValue < 5000)
    {
        return @"小于5千米";
    }
    else
    {
        return @"大于5千米";
    }
}

+ (NSString *)getFansString:(NSString *)count
{
    int n = count.intValue;
    
    if (n > 9999)
    {
        return [NSString stringWithFormat:@"%d万", n/10000];
    }
    else
    {
        return count;
    }
}

@end
