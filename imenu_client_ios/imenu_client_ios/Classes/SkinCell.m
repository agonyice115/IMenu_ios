//
//  SkinCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-12.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "SkinCell.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "IMConfig.h"

@interface SkinCell ()

@property (nonatomic, strong) UIView *skinIcon;
@property (nonatomic, strong) UILabel *skinTitle;
@property (nonatomic, strong) UIImageView *skinImage;

@end

@implementation SkinCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.skinIcon = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        self.skinIcon.center = CGPointMake(PAGE_MARGIN+10, self.frame.size.height/2);
        self.skinIcon.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.skinIcon];
        
        self.skinImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.skinImage.center = CGPointMake(self.frame.size.width-PAGE_MARGIN-10, self.frame.size.height/2);
        self.skinImage.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:self.skinImage];
        
        self.skinTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-PAGE_MARGIN*2-40*2, 20)];
        self.skinTitle.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        self.skinTitle.backgroundColor = [UIColor clearColor];
        self.skinTitle.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        self.skinTitle.textAlignment = NSTextAlignmentLeft;
        self.skinTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        self.skinTitle.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:self.skinTitle];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    if (selected)
    {
        self.skinImage.image = [UIImage imageNamed:@"right.png"];
    }
    else
    {
        self.skinImage.image = nil;
    }
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    self.skinIcon.backgroundColor = [UIColor colorWithHtmlColor:data[@"client_skin_value"]];
    self.skinTitle.text = data[@"client_skin_name"];
}

@end
