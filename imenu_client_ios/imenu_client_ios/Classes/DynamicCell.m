//
//  DynamicCell.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicCell.h"
#import "MenuPhotoView.h"
#import "RoundHeadView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "IMConfig.h"

@interface DynamicCell ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *dynamicTime;
@property (nonatomic, strong) UILabel *dynamicTitle;
@property (nonatomic, strong) UILabel *pubulicTitle;

@property (nonatomic, strong) UIButton *shopName;
@property (nonatomic, strong) UIButton *good;
@property (nonatomic, strong) UIButton *comment;
@property (nonatomic, strong) UIButton *shopDistance;

@property (nonatomic, strong) NSMutableArray *menuList;

@property (nonatomic, strong) NSDictionary *memberInfo;

@end

@implementation DynamicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor whiteColor];
        
        self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        self.topView.backgroundColor = [UIColor whiteColor];
        [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickUserHead)]];
        [self addSubview:self.topView];
        
        float height = 10.0f;
        self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(10, height, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        self.headView.roundSideWidth = 1.0f;
        self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        [self addSubview:self.headView];
        
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(10+IMAGE_SIZE_TINY+10, height+10, 185, 20)];
        self.userName.backgroundColor = [UIColor clearColor];
        self.userName.text = @"用户昵称";
        self.userName.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
        self.userName.textAlignment = NSTextAlignmentLeft;
        self.userName.textColor = [UIColor colorWithHtmlColor:@"#576b95"];
        [self addSubview:self.userName];
        
        self.dynamicTime = [[UILabel alloc] initWithFrame:CGRectMake(260-PAGE_MARGIN, height+5, 60, 20)];
        self.dynamicTime.backgroundColor = [UIColor clearColor];
        self.dynamicTime.text = @"03/01";
        self.dynamicTime.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        self.dynamicTime.textAlignment = NSTextAlignmentRight;
        self.dynamicTime.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.dynamicTime];
        
        height += IMAGE_SIZE_TINY+10.0f;
        self.dynamicTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 300, 20)];
        self.dynamicTitle.backgroundColor = [UIColor clearColor];
        self.dynamicTitle.text = @"今天去了一个超级棒的地方吃饭，可好吃了";
        self.dynamicTitle.font = [UIFont boldSystemFontOfSize:THIRD_FONT_SIZE];
        self.dynamicTitle.textAlignment = NSTextAlignmentLeft;
        self.dynamicTitle.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [self addSubview:self.dynamicTitle];
        
        height += 30.0f;
        self.menuList = [NSMutableArray array];
        MenuPhotoView *photoView = [[MenuPhotoView alloc] initWithFrame:CGRectMake(6, height, IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
        [self addSubview:photoView];
        [self.menuList addObject:photoView];
        
        photoView = [[MenuPhotoView alloc] initWithFrame:CGRectMake(10+IMAGE_SIZE_MIDDLE, height, IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
        [self addSubview:photoView];
        [self.menuList addObject:photoView];
        
        photoView = [[MenuPhotoView alloc] initWithFrame:CGRectMake(14+IMAGE_SIZE_MIDDLE*2, height, IMAGE_SIZE_MIDDLE, IMAGE_SIZE_MIDDLE)];
        [self addSubview:photoView];
        [self.menuList addObject:photoView];
        
        height += 110.0f;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN, height, 290, 20);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [button setTitle:@"商铺名称商铺名称商铺名称商铺名称商铺名称" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"shop_gray"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.enabled = NO;
        [self addSubview:button];
        self.shopName = button;
        
        height += 30.0f;
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN, height, 150, 16);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"距离:小于50米" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"map_normal"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 7)];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        button.enabled = NO;
        [self addSubview:button];
        self.shopDistance = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+220, height-4, 40, 23);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"24" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"good_gray"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.enabled = NO;
        [self addSubview:button];
        self.good = button;
        
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(PAGE_MARGIN+260, height-4, 40, 23);
        button.titleLabel.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        [button setTitle:@"24" forState:UIControlStateDisabled];
        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateDisabled];
        [button setImage:[UIImage imageNamed:@"comment_gray"] forState:UIControlStateDisabled];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.enabled = NO;
        [self addSubview:button];
        self.comment = button;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, height+29, 320, 1)];
        lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#cccccc"];
        [self addSubview:lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    self.backgroundColor = [UIColor colorWithHtmlColor:@"#eeeeee"];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self performSelector:@selector(resetToWhiteColor:) withObject:nil afterDelay:0.5f];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    [self performSelector:@selector(resetToWhiteColor:) withObject:nil afterDelay:0.5f];
}

- (void)clickUserHead
{
    self.topView.backgroundColor = [UIColor colorWithHtmlColor:@"#eeeeee"];
    [self performSelector:@selector(resetToWhiteColor:) withObject:self.topView afterDelay:0.5f];
    
    if (self.delegate)
    {
        [self.delegate onClickUser:self.memberInfo];
    }
}

- (void)resetToWhiteColor:(UIView *)view
{
    if (view)
    {
        view.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor whiteColor];
    }
}

- (void)setData:(NSDictionary *)data andMemberInfo:(NSDictionary *)memberInfo
{
    _data = data;
    _memberInfo = memberInfo;
    
    self.dynamicTitle.text = data[@"title"];
    
    self.userName.text = memberInfo[@"member_name"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:data[@"dynamic_date"]];
    NSDate *now = [NSDate date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dDate = [dateFormatter stringFromDate:date];
    NSString *nDate = [dateFormatter stringFromDate:now];
    
    if ([dDate isEqualToString:nDate])
    {
        [dateFormatter setDateFormat:@"HH:mm"];
    }
    else
    {
        [dateFormatter setDateFormat:@"MM/dd"];
    }
    
    self.dynamicTime.text = [dateFormatter stringFromDate:date];
    
    NSString *vipLevel = memberInfo[@"vip_level"];
    if (vipLevel && vipLevel.intValue > 0)
    {
        // 根据VIP等级加载VIP图片
        self.headView.vipPic = [UIImage imageNamed:[NSString stringWithFormat:@"user_vip_%@@2x.png", vipLevel]];
    }
    
    self.headView.headPic = [UIImage imageNamed:@"man_header_small.png"];
    NSString *url = [TFTools getThumbImageUrlOfLacation:memberInfo[@"iconLocation"] andName:memberInfo[@"iconName"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    NSDictionary *storeInfo = data[@"store_info"];
    [self.shopName setTitle:storeInfo[@"store_name"] forState:UIControlStateDisabled];
    [self.good setTitle:data[@"goods_count"] forState:UIControlStateDisabled];
    [self.comment setTitle:data[@"comment_count"] forState:UIControlStateDisabled];
    [self.shopDistance setTitle:[NSString stringWithFormat:@"距离:%@", [TFTools getDistaceString:data[@"distance"]]]
                       forState:UIControlStateDisabled];
    
    NSArray *menuList = data[@"menu_list"];
    NSUInteger i = 0;
    for (; i < menuList.count && i < 3; i++)
    {
        NSDictionary *menu = menuList[i];
        MenuPhotoView *photoView = self.menuList[i];
        photoView.hidden = NO;
        photoView.dishesName.text = menu[@"menu_name"];
        
        NSString *thumbUrl = [TFTools getThumbImageUrlOfLacation:menu[@"image_location"]
                                                         andName:menu[@"image_name"]];
        if (thumbUrl && [thumbUrl length] > 0)
        {
            [photoView.imageView setImageWithURL:[NSURL URLWithString:thumbUrl] placeholderImage:[UIImage imageNamed:@"default_small.png"]];
        }
        else
        {
            photoView.imageView.image = [UIImage imageNamed:@"default_small.png"];
        }
    }
    
    for (; i < 3; i++)
    {
        MenuPhotoView *photoView = self.menuList[i];
        photoView.hidden = YES;
    }
}

- (void)setData:(NSDictionary *)data
{
    NSDictionary *memberInfo = data[@"member_info"];
    
    [self setData:data andMemberInfo:memberInfo];
}

- (void)setIsPublic:(BOOL)isPublic
{
    _isPublic = isPublic;
    
    self.dynamicTitle.frame = CGRectMake(70, IMAGE_SIZE_TINY+10, 240, 28);
    
    if (self.pubulicTitle == nil)
    {
        self.pubulicTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, IMAGE_SIZE_TINY+10, 60, 28)];
        self.pubulicTitle.backgroundColor = [UIColor clearColor];
        self.pubulicTitle.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
        self.pubulicTitle.textAlignment = NSTextAlignmentLeft;
    }
    self.pubulicTitle.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    
    NSString *public = @"(未发布)";
    if (isPublic)
    {
        public = @"(已发布)";
        self.pubulicTitle.textColor = [IMConfig sharedConfig].bgColor;
    }
    self.pubulicTitle.text = public;
    
    [self addSubview:self.pubulicTitle];
}

@end
