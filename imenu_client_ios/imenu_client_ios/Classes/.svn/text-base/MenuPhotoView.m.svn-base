//
//  MenuPhotoView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "MenuPhotoView.h"
#import "UIColor+HtmlColor.h"
#import "Common.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TFTools.h"

@interface MenuPhotoView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation MenuPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
        self.clipsToBounds = NO;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        [self addSubview:self.imageView];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-24, frame.size.width, 24)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        [self addSubview:view];
        self.bgView = view;
        
        self.dishesName = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, frame.size.width-10, 20)];
        self.dishesName.backgroundColor = [UIColor clearColor];
        self.dishesName.text = @"特价爆米花";
        self.dishesName.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dishesName.textAlignment = NSTextAlignmentLeft;
        self.dishesName.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
        [view addSubview:self.dishesName];
        
        self.borderView = [[UIView alloc] initWithFrame:self.bounds];
        self.borderView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.borderView];
    }
    return self;
}

- (void)setShowCamera:(BOOL)showCamera
{
    _showCamera = showCamera;
    
    if (showCamera)
    {
        UIImageView *cameraView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        cameraView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2-12);
        cameraView.image = [UIImage imageNamed:@"camera_normal@2x.png"];
        [self addSubview:cameraView];
        [self sendSubviewToBack:cameraView];
    }
}

- (void)setShowDelete:(BOOL)showDelete
{
    _showDelete = showDelete;
    
    if (showDelete)
    {
        UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteButton.frame = CGRectMake(self.frame.size.width-12, self.frame.size.height-20, 23, 23);
        [deleteButton setImage:[UIImage imageNamed:@"camera_delete.png"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
    }
}

- (void)setShowCommentAndGoods:(BOOL)showCommentAndGoods
{
    _showCommentAndGoods = showCommentAndGoods;
    
    NSString *imageId = self.data[@"member_menu_image_id"];
    
    if (showCommentAndGoods && imageId && imageId.length > 0)
    {
        self.bgView.frame = CGRectMake(0, self.frame.size.height-40, self.frame.size.width, 40);
        
        self.good = [UIButton buttonWithType:UIButtonTypeCustom];
        self.good.frame = CGRectMake(0, 19, self.frame.size.width/2, 23);
        self.good.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.good setTitle:self.data[@"goods_count"] forState:UIControlStateNormal];
        [self.good setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [self.good setImage:[UIImage imageNamed:@"good_white"] forState:UIControlStateNormal];
        self.good.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.good.userInteractionEnabled = NO;
        [self.bgView addSubview:self.good];
        
        self.comment = [UIButton buttonWithType:UIButtonTypeCustom];
        self.comment.frame = CGRectMake(self.frame.size.width/2, 19, self.frame.size.width/2, 23);
        self.comment.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [self.comment setTitle:self.data[@"comment_count"] forState:UIControlStateNormal];
        [self.comment setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
        [self.comment setImage:[UIImage imageNamed:@"comment_white"] forState:UIControlStateNormal];
        self.comment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        self.comment.userInteractionEnabled = NO;
        [self.bgView addSubview:self.comment];
    }
}

- (void)setShowName:(BOOL)showName
{
    _showName = showName;
    
    if (!showName)
    {
        self.dishesName.hidden = YES;
        if (self.good)
        {
            self.bgView.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
            self.good.frame = CGRectMake(0, -1, self.frame.size.width/2, 23);
            self.comment.frame = CGRectMake(self.frame.size.width/2, -1, self.frame.size.width/2, 23);
        }
    }
}

- (void)deleteImage:(id)sender
{
    self.imageView.image = nil;
}

@end
