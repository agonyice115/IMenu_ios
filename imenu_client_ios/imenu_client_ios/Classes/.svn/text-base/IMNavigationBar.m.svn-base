//
//  IMNavigationBar.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-11-28.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMNavigationBar.h"
#import "IMConfig.h"
#import "IMNavigationController.h"
#import "UIColor+HtmlColor.h"

@interface IMNavigationBar ()

/**
 *  内容视图
 */
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIView *barView;

@property (nonatomic, assign) IM_NAVIGATION_BAR_TYPE currentType;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *lastTitle;

@end

@implementation IMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIColorChanged:) name:IM_UICOLOR_CHANGED object:nil];
        
        self.currentType = IM_NAVIGATION_BAR_TYPE_NONE;
        self.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 1);
        self.layer.shadowOpacity = 0.5;
        
        CGRect contentFrame = self.bounds;
        contentFrame.origin.y += 20.0f;
        contentFrame.size.height -= 20.0f;
        
        self.lastTitle = @"朋友动态";
        
        self.contentView = [[UIView alloc] initWithFrame:contentFrame];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.clipsToBounds = YES;
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)UIColorChanged:(NSNotification *)notification
{
    self.backgroundColor = [[IMConfig sharedConfig].bgColor colorWithAlphaComponent:0.8f];
}

- (void)setNavigationBarType:(IM_NAVIGATION_BAR_TYPE)type animated:(BOOL)animated fromTop:(BOOL)top
{
    if (self.currentType == IM_NAVIGATION_BAR_TYPE_UNLOGIN_SECONDARY && self.currentType == type)
    {
        return;
    }
    
    self.currentType = type;
    
    UIView *view = [self getBarViewWithType:type];
    if (animated && self.barView)
    {
        CGRect frame = self.barView.frame;
        if (top)
        {
            view.frame = CGRectOffset(frame, 0, -frame.size.height);
        }
        else
        {
            view.frame = CGRectOffset(frame, 0, frame.size.height);
        }
        [self.contentView addSubview:view];
        
        [UIView animateWithDuration:0.2f animations:^{
            view.frame = frame;
            if (top)
            {
                self.barView.frame = CGRectOffset(frame, 0, frame.size.height);
            }
            else
            {
                self.barView.frame = CGRectOffset(frame, 0, -frame.size.height);
            }
        } completion:^(BOOL finished) {
            [self.barView removeFromSuperview];
            self.barView = view;
        }];
    }
    else
    {
        if (self.barView)
        {
            [self.barView removeFromSuperview];
        }
        self.barView = view;
        [self.contentView addSubview:self.barView];
    }
}

- (void)onClickItem:(id)sender
{
    UIButton *button = sender;
    [self.imNavigationController onNavigationItemClicked:button.tag];
}

- (UIView *)getBarViewWithType:(IM_NAVIGATION_BAR_TYPE)type
{
    UIView *view = [[UIView alloc] initWithFrame:self.contentView.bounds];
    view.backgroundColor = [UIColor clearColor];
    
    switch (type)
    {
        case IM_NAVIGATION_BAR_TYPE_UNLOGIN:
            [self createUnLoginBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_UNLOGIN_SECONDARY:
            [self createUnLoginSecondaryBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_MINE:
            [self createMineBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_DYNIMIC:
            [self createDynamicBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_SHOP:
            [self createShopBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_SERCH:
            [self createSerchBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_SWITCH:
            [self createSwitchBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_TITLE:
            [self createTitleBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SHARE:
            [self createTitleWithShareBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_TITLE_WITH_SEARCH:
            [self createTitleWithSearchBar:view];
            break;
            
        case IM_NAVIGATION_BAR_TYPE_SHARE:
            [self createShareBar:view];
            break;
            
        default:
            NSAssert(NO, @"未定义的导航栏类型：%d", type);
            break;
    }
    
    return view;
}

- (UIButton *)createTextButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:SECOND_FONT_SIZE];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onClickItem:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)createUnLoginBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"main_title3", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHOP;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(220, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"unlogin_title_login", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_LOGIN;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(260, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"unlogin_title_register", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_REGISTER;
    [view addSubview:button];
    
    UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+40, 20, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle.png"];
    [view addSubview:triangle];
}

- (void)createUnLoginSecondaryBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN-11, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    button.tag = IM_NAVIGATION_ITEM_BACK;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(230, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"unlogin_title_login", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_LOGIN;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(270, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"unlogin_title_register", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_REGISTER;
    [view addSubview:button];
}

- (void)createMineBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"main_title1", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_MINE;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-80, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHARE;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
}

- (void)createDynamicBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"main_title2", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_DYNIMIC;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
    
    UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+36, 24, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle.png"];
    triangle.transform = CGAffineTransformMakeRotation(-M_PI_4);
    [view addSubview:triangle];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 100, 25)];
    self.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = self.lastTitle;
    [view addSubview:self.titleLabel];
}

- (void)setMiddleTitle:(NSString *)title
{
    if (self.titleLabel)
    {
        self.titleLabel.text = title;
    }
    
    self.lastTitle = title;
}

- (void)createShopBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN-10, 0, 50, 45);
    [button setTitle:NSLocalizedString(@"main_title3", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHOP;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-80, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_MAP;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
    
    UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+40, 20, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle.png"];
    [view addSubview:triangle];
}

- (void)createSerchBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN, 10, 40, 25);
    [button setTitle:NSLocalizedString(@"main_title4", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SERCH;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
}

- (void)createSwitchBar:(UIView *)view
{
    view.backgroundColor = [UIColor blackColor];
    
    float x = PAGE_MARGIN-10;
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(x, 0, 50, 45);
    [button setTitle:NSLocalizedString(@"main_title1", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH_MINE;
    [view addSubview:button];
    
    x += 65;
    button = [self createTextButton];
    button.frame = CGRectMake(x, 0, 50, 45);
    [button setTitle:NSLocalizedString(@"main_title2", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH_DYNIMIC;
    [view addSubview:button];
    
    x += 65;
    button = [self createTextButton];
    button.frame = CGRectMake(x, 0, 50, 45);
    [button setTitle:NSLocalizedString(@"main_title3", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH_SHOP;
    [view addSubview:button];
    
    x += 65;
    button = [self createTextButton];
    button.frame = CGRectMake(x, 0, 50, 45);
    [button setTitle:NSLocalizedString(@"main_title4", nil) forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH_SERCH;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"close_highlight"] forState:UIControlStateHighlighted];
    button.tag = IM_NAVIGATION_ITEM_CLOSE;
    [view addSubview:button];
    
    int index = 0;
    
    switch ([self.imNavigationController getCurrentViewKindId])
    {
        case IM_NAVIGATION_ITEM_SWITCH_MINE:
            index = 0;
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_DYNIMIC:
            index = 1;
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_SHOP:
            index = 2;
            break;
            
        case IM_NAVIGATION_ITEM_SWITCH_SERCH:
            index = 3;
            break;
            
        default:
            break;
    }
    
    UIImageView *triangle = [[UIImageView alloc] initWithFrame:CGRectMake(PAGE_MARGIN+index*65+10, 33, 10, 5)];
    triangle.image = [UIImage imageNamed:@"triangle.png"];
    [view addSubview:triangle];
}

- (void)createShareBar:(UIView *)view
{
    view.backgroundColor = [UIColor blackColor];
    
    float x = PAGE_MARGIN-10;
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(x, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"wechat_white"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHARE_WECHAT;
    [view addSubview:button];
    
    x += 65;
    button = [self createTextButton];
    button.frame = CGRectMake(x, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"friends_white"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHARE_FRIENDS;
    [view addSubview:button];
    
    x += 65;
    button = [self createTextButton];
    button.frame = CGRectMake(x, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"sina_white"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHARE_SINA;
    [view addSubview:button];
    
    x += 65;
    button = [self createTextButton];
    button.frame = CGRectMake(x, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"renren_white"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHARE_RENREN;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"close_highlight"] forState:UIControlStateHighlighted];
    button.tag = IM_NAVIGATION_ITEM_CLOSE;
    [view addSubview:button];
}

- (void)createTitleBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN-11, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    button.tag = IM_NAVIGATION_ITEM_BACK;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(60, 10, 200, 25);
    [button setTitle:[self.imNavigationController getCurrentViewTitle] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_TITLE;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
}

- (void)createTitleWithShareBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN-11, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    button.tag = IM_NAVIGATION_ITEM_BACK;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(60, 10, 160, 25);
    [button setTitle:[self.imNavigationController getCurrentViewTitle] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_TITLE;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-80, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SHARE;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
}

- (void)createTitleWithSearchBar:(UIView *)view
{
    UIButton *button = [self createTextButton];
    button.frame = CGRectMake(PAGE_MARGIN-11, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"back_normal"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"back_highlight"] forState:UIControlStateHighlighted];
    button.tag = IM_NAVIGATION_ITEM_BACK;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(60, 10, 160, 25);
    [button setTitle:[self.imNavigationController getCurrentViewTitle] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_TITLE;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-80, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"search_white"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SEARCH_MENU;
    [view addSubview:button];
    
    button = [self createTextButton];
    button.frame = CGRectMake(view.frame.size.width-PAGE_MARGIN-34, 0.0f, 45.0f, 45.0f);
    [button setImage:[UIImage imageNamed:@"menu_normal"] forState:UIControlStateNormal];
    button.tag = IM_NAVIGATION_ITEM_SWITCH;
    [view addSubview:button];
}

@end
