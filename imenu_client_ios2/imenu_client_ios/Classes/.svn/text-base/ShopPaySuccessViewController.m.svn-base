//
//  ShopPaySuccessViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-30.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ShopPaySuccessViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "IMBgView.h"
#import "IMPopViewController.h"
#import "NewOrderViewController.h"

@interface ShopPaySuccessViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ShopPaySuccessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSDictionary *orderInfo = self.data[@"order_info"];
    NSDictionary *storeInfo = orderInfo[@"store_info"];
    NSDictionary *consumeInfo = orderInfo[@"consume_info"];
    NSDictionary *scoreInfo = self.data[@"score_info"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    float x = 50.0f;
    float y = TOP_BAR_HEIGHT + 30;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, 46, 46)];
    imageView.image = [UIImage imageNamed:@"pay_success"];
    [self.scrollView addSubview:imageView];
    
    x += 60;
    y += 15;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 160, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE+2];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"订单已提交!";
    [self.scrollView addSubview:label];
    
    x = 50.0f;
    y += 50;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"合计：";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+50, y, 90, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
    label.text = [NSString stringWithFormat:@"￥%.2f", [orderInfo[@"total"] floatValue]];
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+140, y, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = [NSString stringWithFormat:@"获得%@点积分", scoreInfo[@"add_score"]];
    [self.scrollView addSubview:label];
    
    x = 10.0f;
    y += 40;
    
    IMBgView *bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    [self.scrollView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_shop"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    label.text = storeInfo[@"store_name"];
    [self.scrollView addSubview:label];
    
    y += 50;
    
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    bgView.borderType = IMBgViewType_RoundTop;
    [self.scrollView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_order"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#888888"];
    label.text = @"您的订单消费号码";
    [self.scrollView addSubview:label];
    
    y += 40 - 2;
    
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    bgView.borderType = IMBgViewType_RoundBottom;
    [self.scrollView addSubview:bgView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = consumeInfo[@"consume_code"];
    [self.scrollView addSubview:label];
    
    y += 60;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 145, 40);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d35d53"];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithHtmlColor:@"#d35d53"].CGColor;
    [button setTitle:@"查看订单详情" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button addTarget:self action:@selector(goOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x+155, y, 145, 40);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d6edfd"];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithHtmlColor:@"#d6edfd"].CGColor;
    [button setTitle:@"继续浏览" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#2798f4"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    y += 60;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 300, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE-1];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"您稍后会收到一条来自微点的包含消费号码的订餐确认短信";
    [self.scrollView addSubview:label];
    
    y += 60;
    
    self.scrollView.contentSize = CGSizeMake(320, y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    [pVC backToMainView];
}

- (void)goOrderDetail
{
    IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
    
    NewOrderViewController *vc = [[NewOrderViewController alloc] initWithNibName:nil bundle:nil];
    NSDictionary *orderInfo = self.data[@"order_info"];
    vc.orderId = orderInfo[@"order_id"];
    [pVC setRootViewController:vc withTitle:@"订单详情" animated:YES];
}

@end
