//
//  ShopAnnotationView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-5.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopAnnotationView.h"
#import "UIColor+HtmlColor.h"
#import "ShopAnnotation.h"
#import <SDWebImage/SDWebImageManager.h>

#define kAnnotationWidth 50.0f
#define kCornerRadius 3.0f

@interface ShopAnnotationView ()

@property (nonatomic, strong) UIImage *logoImage;
@property (nonatomic, strong) NSString *index;

@end

@implementation ShopAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, kAnnotationWidth, kAnnotationWidth+15.0f);
        self.centerOffset = CGPointMake(0, -7.5f);
        self.backgroundColor = [UIColor clearColor];
        self.logoImage = [UIImage imageNamed:@"shop_logo_small.png"];
        
        [self resetData];
    }
    
    return self;
}

- (void)resetData
{
    ShopAnnotation *shopAnnotation = self.annotation;
    self.index = [NSString stringWithFormat:@"%d", shopAnnotation.index];
    __weak ShopAnnotationView *_wself = self;
    
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:shopAnnotation.thumbUrl]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image && _wself)
                                                 {
                                                     _wself.logoImage = image;
                                                 }
                                             }];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.0f);
    
    rect = CGRectMake(0, 15, kAnnotationWidth, kAnnotationWidth);
    UIColor *fillColor = [[UIColor colorWithHtmlColor:@"#444444"] colorWithAlphaComponent:0.2f];
    
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    rect = CGRectInset(rect, 1.0f, 1.0f);
    fillColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    
    CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
    CGContextSetFillColorWithColor(context, fillColor.CGColor);
    CGContextAddEllipseInRect(context, rect);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    rect = CGRectInset(rect, 2.0f, 2.0f);
    CGContextSaveGState(context);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self.logoImage drawInRect:rect];
    CGContextRestoreGState(context);
    
    if (!self.hideIndex)
    {
        rect = CGRectMake(0, 0, 25, 20);
        CGContextSetLineWidth(context, 1.0f);
        UIColor *strokeColor = [UIColor colorWithHtmlColor:@"#ffffff"];
        fillColor = [[UIColor colorWithHtmlColor:@"#008fff"] colorWithAlphaComponent:0.7f];
        CGContextSetStrokeColorWithColor(context, strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextMoveToPoint(context, CGRectGetMinX(rect)+kCornerRadius, CGRectGetMinY(rect));
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect)+kCornerRadius, kCornerRadius);
        CGContextAddArcToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMaxX(rect)-kCornerRadius, CGRectGetMaxY(rect), kCornerRadius);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-kCornerRadius, CGRectGetMaxY(rect)+kCornerRadius);
        CGContextAddLineToPoint(context, CGRectGetMaxX(rect)-kCornerRadius*3, CGRectGetMaxY(rect));
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect)-kCornerRadius, kCornerRadius);
        CGContextAddArcToPoint(context, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMinX(rect)+kCornerRadius, CGRectGetMinY(rect), kCornerRadius);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        [strokeColor set];
        [self.index drawInRect:rect withFont:[UIFont systemFontOfSize:15.0f] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
}

- (void)setLogoImage:(UIImage *)logoImage
{
    _logoImage = logoImage;
    
    [self setNeedsDisplay];
}

@end
