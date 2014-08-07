//
//  OrderPayViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-13.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "OrderPayViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "IMBgView.h"
#import "RoundHeadView.h"
#import "IMPopViewController.h"
#import "PaySuccesViewController.h"
#import "PayFailViewController.h"
#import "UserData.h"
#import "Networking.h"
#import "AlixLibService.h"
#import "TFTools.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OrderPayViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RoundHeadView *headView;

@property (nonatomic, strong) NSString *payType;
@property (nonatomic, strong) UIImageView *alipayIcon;
@property (nonatomic, strong) UIImageView *wechatIcon;

@end

@implementation OrderPayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;
        self.payType = @"1";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *orderInfo = self.data[@"order_info"];
    NSDictionary *storeInfo = orderInfo[@"store_info"];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    float x = 10.0f;
    float y = TOP_BAR_HEIGHT + 10;
    
    IMBgView *bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 100)];
    bgView.borderColor = [UIColor colorWithHtmlColor:@"#e9f6fe"];
    bgView.fillColor = [UIColor colorWithHtmlColor:@"#e9f6fe"];
    [self.scrollView addSubview:bgView];
    
    x += 20;
    y += 10;
    
    self.headView = [[RoundHeadView alloc] initWithFrame:CGRectMake(x, y, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
    self.headView.headPic = [UIImage imageNamed:@"shop_logo_small.png"];
    self.headView.roundSideWidth = 2.0f;
    [self.scrollView addSubview:self.headView];
    
    NSString *url = [TFTools getThumbImageUrlOfLacation:storeInfo[@"store_logo_location"] andName:storeInfo[@"store_logo_name"]];
    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                               options:0
                                              progress:nil
                                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                 if (finished && image)
                                                 {
                                                     self.headView.headPic = image;
                                                 }
                                             }];
    
    x += IMAGE_SIZE_TINY + 10;
    y += 10;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 220, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = storeInfo[@"store_name"];
    [self.scrollView addSubview:label];
    
    y += 20;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"人数：";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+50, y, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
    label.text = [NSString stringWithFormat:@"%@人", orderInfo[@"people"]];
    [self.scrollView addSubview:label];
    
    y += 20;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"合计：";
    [self.scrollView addSubview:label];
    
    NSString *total = orderInfo[@"total"];
    NSString *originalTotal = orderInfo[@"original_total"];
    
    if ([total isEqualToString:originalTotal])
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(x+50, y, 80, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = [NSString stringWithFormat:@"￥%.2f", total.floatValue];
        [self.scrollView addSubview:label];
    }
    else
    {
        label = [[UILabel alloc] initWithFrame:CGRectMake(x+50, y, 80, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:FIRST_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#eb8400"];
        label.text = [NSString stringWithFormat:@"￥%.2f", total.floatValue];
        [self.scrollView addSubview:label];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(x+130, y, 80, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
        label.textColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        label.text = [NSString stringWithFormat:@"￥%.2f", originalTotal.floatValue];
        label.clipsToBounds = YES;
        [self.scrollView addSubview:label];
        
        [label sizeToFit];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 10, 100, 1)];
        line.backgroundColor = [UIColor colorWithHtmlColor:@"#aaaaaa"];
        [label addSubview:line];
    }
    
    x = 10.0f;
    y += 40;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 160, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"您绑定的手机号码";
    [self.scrollView addSubview:label];
    
    y += 20;
    
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    [self.scrollView addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_phone"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = [[UserData sharedUserData].mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(250, y+10, 50, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = @"已验证";
    [self.scrollView addSubview:label];
    
    y += 50;
    
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    [self.scrollView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_user_verify"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+10, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = @"代金券/积分";
    [self.scrollView addSubview:label];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(278, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"right_more_normal"];
    [self.scrollView addSubview:imageView];
    
    y += 40;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 160, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"请选择支付方式";
    [self.scrollView addSubview:label];
    
    y += 20;
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    bgView.borderType = IMBgViewType_RoundTop;
    [self.scrollView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_zfb"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+4, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = @"支付宝支付";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+18, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE-2];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"推荐安装支付宝客户端的用户使用";
    [self.scrollView addSubview:label];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(278, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_selected"];
    [self.scrollView addSubview:imageView];
    self.alipayIcon = imageView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 300, 40);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(onClickAlipay) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    y += 40 - 2;
    bgView = [[IMBgView alloc] initWithFrame:CGRectMake(x, y, 300, 40)];
    bgView.borderType = IMBgViewType_RoundBottom;
    [self.scrollView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x+9, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_wechat"];
    [self.scrollView addSubview:imageView];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+4, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#2798f4"];
    label.text = @"微信支付";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+40, y+18, 200, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE-2];
    label.textColor = [UIColor colorWithHtmlColor:@"#cccccc"];
    label.text = @"推荐安装微信5.0或更高版本的用户使用";
    [self.scrollView addSubview:label];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(278, y+9, 22, 22)];
    imageView.image = [UIImage imageNamed:@"pay_unselected"];
    [self.scrollView addSubview:imageView];
    self.wechatIcon = imageView;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 300, 40);
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(onClickWechat) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    y += 50;
    
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(x, y, 300, 40);
    button.backgroundColor = [UIColor colorWithHtmlColor:@"#d35d53"];
    button.layer.cornerRadius = 5.0f;
    button.layer.masksToBounds = YES;
    button.layer.borderWidth = 1.0f;
    button.layer.borderColor = [UIColor colorWithHtmlColor:@"#d35d53"].CGColor;
    [button setTitle:@"确认支付" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHtmlColor:@"#ffffff"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    [button addTarget:self action:@selector(onClickPay) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    
    y += 50;
    
    self.scrollView.contentSize = CGSizeMake(320, y);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickAlipay
{
    if ([self.payType isEqualToString:@"1"])
    {
        return;
    }
    
    self.payType = @"1";
    self.alipayIcon.image = [UIImage imageNamed:@"pay_selected"];
    self.wechatIcon.image = [UIImage imageNamed:@"pay_unselected"];
}

- (void)onClickWechat
{
    if ([self.payType isEqualToString:@"2"])
    {
        return;
    }
    
    self.payType = @"2";
    self.wechatIcon.image = [UIImage imageNamed:@"pay_selected"];
    self.alipayIcon.image = [UIImage imageNamed:@"pay_unselected"];
}

- (void)onClickPay
{
    NSDictionary *orderInfo = self.data[@"order_info"];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"member_id"] = [UserData sharedUserData].memberId;
    dic[@"payment_type"] = self.payType;
    dic[@"order_id"] = orderInfo[@"order_id"];
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"order/order/generatePayData" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSDictionary *payData = result[@"data"];
                
                NSLog(@"=======payOrder=======\n%@", payData[@"payment_order_param"]);
                
                NSString *payOrder = payData[@"payment_order_param"];
                
                [AlixLibService payOrder:payOrder AndScheme:@"alipay.siyo" seletor:@selector(paymentResult:) target:self];
//                IMPopViewController *pVC = (IMPopViewController *)self.parentViewController;
//                
//                PayFailViewController *viewController = [[PayFailViewController alloc] initWithNibName:nil bundle:nil];
//                [pVC setRootViewController:viewController withTitle:@"支付结果" animated:YES];
            }
        });
    });
}

-(void)paymentResult:(NSString *)result
{
    NSLog(@"=======result=======\n%@", result);
    
    [UIView transitionFromView:[UIApplication sharedApplication].keyWindow.rootViewController.view
                        toView:self.parentViewController.view duration:0 options:0 completion:nil];
}

@end
