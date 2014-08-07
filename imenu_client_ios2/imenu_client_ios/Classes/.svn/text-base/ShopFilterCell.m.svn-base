//
//  ShopFilterCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-4.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopFilterCell.h"
#import "IMConfig.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMConfig.h"

@interface ShopFilterCell ()

@property (nonatomic, strong) UIImageView *filterIcon;
@property (nonatomic, strong) UILabel *filterTitle;
@property (nonatomic, strong) UIImageView *filterImage;

@end

@implementation ShopFilterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [IMConfig sharedConfig].bgColor;
        view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight;
        self.selectedBackgroundView = view;
        
        self.filterIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.filterIcon.center = CGPointMake(PAGE_MARGIN+10, self.frame.size.height/2);
        self.filterIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.filterIcon];
        
        self.filterImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.filterImage.center = CGPointMake(self.frame.size.width-PAGE_MARGIN, self.frame.size.height/2);
        self.filterImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.filterImage];
        
        self.filterTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-PAGE_MARGIN*2-40, 20)];
        self.filterTitle.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.filterTitle.backgroundColor = [UIColor clearColor];
        self.filterTitle.text = @"高新区";
        self.filterTitle.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.filterTitle.textAlignment = NSTextAlignmentLeft;
        self.filterTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.filterTitle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.filterTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        self.filterTitle.textColor = [UIColor whiteColor];
    }
    else
    {
        self.filterTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    }
    
    if (self.isCheckLevel)
    {
        NSString *level = self.data[@"level"];
        if ([level isEqualToString:@"2"])
        {
            if (selected)
            {
                self.filterImage.image = [UIImage imageNamed:@"check_white@2x.png"];
            }
            else
            {
                self.filterImage.image = nil;
            }
            return;
        }
    }
    
    NSString *children = self.data[@"children"];
    if (children == nil)
    {
        if (selected)
        {
            self.filterImage.image = [UIImage imageNamed:@"check_white@2x.png"];
        }
        else
        {
            self.filterImage.image = nil;
        }
    }
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.filterTitle.text = data[@"title"];
    
    NSString *imageUrl = data[@"image"];
    if (imageUrl == nil || [imageUrl length] == 0)
    {
        self.filterIcon.image = nil;
        CGRect frame = self.filterTitle.frame;
        frame.origin.x = PAGE_MARGIN;
        frame.size.width = self.frame.size.width-PAGE_MARGIN*2-40+25;
        self.filterTitle.frame = frame;
    }
    else
    {
        [self.filterIcon setImageWithURL:[NSURL URLWithString:imageUrl]];
        CGRect frame = self.filterTitle.frame;
        frame.origin.x = PAGE_MARGIN+25;
        frame.size.width = self.frame.size.width-PAGE_MARGIN*2-40;
        self.filterTitle.frame = frame;
    }
    
    if (self.isCheckLevel)
    {
        NSString *level = self.data[@"level"];
        if ([level isEqualToString:@"2"])
        {
            self.filterImage.image = nil;
            return;
        }
    }
    
    NSString *children = self.data[@"children"];
    if (children)
    {
        self.filterImage.image = [UIImage imageNamed:@"right_more_normal@2x.png"];
    }
    else
    {
        self.filterImage.image = nil;
    }
}

@end
