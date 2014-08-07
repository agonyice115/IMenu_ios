//
//  NewOrderViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-20.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "NewOrderViewController.h"
#import "NoteView.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "ShopTopBar.h"
#import "LoginButton.h"
#import "IMPopViewController.h"
#import "NewDynamicViewController.h"
#import "ShopDetailsViewController.h"
#import "IMNavigationController.h"
#import "UserData.h"
#import "Networking.h"

@interface NewOrderViewController ()

@property (nonatomic, strong) ShopTopBar *shopBar;

@property (nonatomic, strong) UILabel *cartPeople;
@property (nonatomic, strong) UILabel *cartCount;
@property (nonatomic, strong) UILabel *cartTotalPrice;
@property (nonatomic, strong) UILabel *cartAveragePrice;

@property (nonatomic, strong) UILabel *scoreTotal;
@property (nonatomic, strong) UILabel *scoreAdd;
@property (nonatomic, strong) UILabel *scoreRed;

@end

@implementation NewOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
        
        float height = TOP_BAR_HEIGHT;
        
        self.shopBar = [[ShopTopBar alloc] initWithFrame:CGRectMake(0, height, 320, MIDDLE_BAR_HEIGHT)];
        self.shopBar.hideRightMore = YES;
        //[self.shopBar addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goShopDetail)]];
        [self.view addSubview:self.shopBar];
        
        height += MIDDLE_BAR_HEIGHT+20;
        NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(10, height, 300, 240)];
        [self.view addSubview:noteView];
        
        float y = 10.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"人　　数：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [noteView addSubview:label];
        self.cartPeople = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"单　　品：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [noteView addSubview:label];
        self.cartCount = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"合　　计：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [noteView addSubview:label];
        self.cartTotalPrice = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"人　　均：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [noteView addSubview:label];
        self.cartAveragePrice = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"总 积 分：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        [noteView addSubview:label];
        self.scoreTotal = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"获得积分：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#00cc00"];
        [noteView addSubview:label];
        self.scoreAdd = label;
        
        y += NOTE_LINE_HEIGHT;
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, 100, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
        label.text = @"扣除积分：";
        [noteView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(200, y, 70, NOTE_LINE_HEIGHT)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#ff0000"];
        [noteView addSubview:label];
        self.scoreRed = label;
        
//        y += NOTE_LINE_HEIGHT+5;
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(10, y, 90, 40);
//        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
//        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateHighlighted];
//        [button setImage:[UIImage imageNamed:@"right_more_normal"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"right_more_highlight"] forState:UIControlStateHighlighted];
//        button.backgroundColor = [UIColor clearColor];
//        [button setTitle:@"全部订单" forState:UIControlStateNormal];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 2, -60);
//        //[button addTarget:self action:@selector(onClickCartButton) forControlEvents:UIControlEventTouchUpInside];
//        [noteView addSubview:button];
//        
//        button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(120, y, 90, 40);
//        button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
//        [button setTitleColor:[UIColor colorWithHtmlColor:@"#5a5a5a"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor colorWithHtmlColor:@"#888888"] forState:UIControlStateHighlighted];
//        [button setImage:[UIImage imageNamed:@"right_more_normal"] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"right_more_highlight"] forState:UIControlStateHighlighted];
//        button.backgroundColor = [UIColor clearColor];
//        [button setTitle:@"积分列表" forState:UIControlStateNormal];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        button.titleEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
//        button.imageEdgeInsets = UIEdgeInsetsMake(0, 60, 2, -60);
//        //[button addTarget:self action:@selector(onClickCartButton) forControlEvents:UIControlEventTouchUpInside];
//        [noteView addSubview:button];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showPublishButton
{
    LoginButton *loginButton = [LoginButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(0, self.view.frame.size.height-BOTTOM_BAR_HEIGHT, 320, BOTTOM_BAR_HEIGHT);
    [loginButton setTitle:NSLocalizedString(@"cart_view_button4", nil) forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:@"enter_normal"] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:@"enter_highlight"] forState:UIControlStateHighlighted];
    [loginButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 10)];
    [loginButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
    [loginButton addTarget:self action:@selector(clickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    NSDictionary *orderInfo = data[@"order_info"];
    
    self.shopBar.storeData = orderInfo[@"store_info"];
    
    NSUInteger count = 0;
    NSString *menuTypeCount = orderInfo[@"menu_type_count"];
    if (menuTypeCount)
    {
        count = menuTypeCount.intValue;
    }
    else
    {
        NSArray *menuList = orderInfo[@"menu_list"];
        count = [menuList count];
    }
    
    self.cartPeople.text = [NSString stringWithFormat:@"%@人", orderInfo[@"people"]];
    self.cartCount.text = [NSString stringWithFormat:@"%d种", count];
    
    NSString *total = orderInfo[@"total"];
    float fTotal = [total floatValue];
    self.cartTotalPrice.text = [NSString stringWithFormat:@"￥%.2f", fTotal];
    self.cartAveragePrice.text = [NSString stringWithFormat:@"￥%.2f", fTotal/([orderInfo[@"people"] intValue])];
    
    NSDictionary *scoreInfo = data[@"score_info"];
    self.scoreTotal.text = [NSString stringWithFormat:@"%@", scoreInfo[@"total_score"]];
    self.scoreAdd.text = [NSString stringWithFormat:@"+%@", scoreInfo[@"add_score"]];
    self.scoreRed.text = [NSString stringWithFormat:@"-%@", scoreInfo[@"minus_score"]];
}

- (void)setOrderId:(NSString *)orderId
{
    _orderId = orderId;
    
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"order_id":orderId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"order/order/getOrderDetail" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    self.data = [result[@"data"] lastObject];
                }
            }
        });
    });
}

- (void)clickNextButton
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    NewDynamicViewController *viewController = [[NewDynamicViewController alloc] initWithNibName:nil bundle:nil];
    viewController.isHidePhoto = YES;
    viewController.dynamicId = self.data[@"dynamic_id"];
    [pVC setRootViewController:viewController withTitle:NSLocalizedString(@"dynimic_view_title", nil) animated:YES];
}

- (void)goShopDetail
{
    UIViewController *viewController = self.presentingViewController;
    NSDictionary *orderInfo = self.data[@"order_info"];
    NSDictionary *storeInfo = orderInfo[@"store_info"];;
    
    if ([viewController isKindOfClass:[IMNavigationController class]])
    {
        IMNavigationController *baseVC = (IMNavigationController *)viewController;
        [self dismissViewControllerAnimated:YES completion:^{
            ShopDetailsViewController *vc = [[ShopDetailsViewController alloc] initWithNibName:nil bundle:nil];
            [vc setStoreId:storeInfo[@"store_id"] andStoreName:storeInfo[@"store_name"]];
            [baseVC pushViewController:vc animated:YES];
        }];
    }
}

@end
