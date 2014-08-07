//
//  PaySuccesViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-7-13.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "PaySuccesViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import "IMBgView.h"

@interface PaySuccesViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PaySuccesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    label.text = @"支付购买成功!";
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
    label.text = @"￥267.00";
    [self.scrollView addSubview:label];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(x+140, y, 100, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:SECOND_FONT_SIZE];
    label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    label.text = @"获得3点积分";
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
    label.text = @"雕刻时光（交大店）";
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
    label.text = @"1590233442322";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
