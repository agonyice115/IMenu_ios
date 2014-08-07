//
//  DynamicMenuDetailViewController.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-2-8.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "DynamicMenuDetailViewController.h"
#import "Common.h"
#import "UIColor+HtmlColor.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CommentInputView.h"
#import "CommentCell.h"
#import "FollowSelectViewController.h"
#import "UserData.h"
#import "Networking.h"
#import "RoundHeadView.h"
#import "TFTools.h"

#define TOP_HEADER_VIEW_HEIGHT 50.0f

@interface DynamicMenuDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIImageView *menuImage;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) CommentInputView *inputView;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) NSArray *commentList;

@property (nonatomic, strong) UILabel *goodCount;
@property (nonatomic, assign) int curGoodCount;
@property (nonatomic, assign) BOOL isGood;
@property (nonatomic, strong) NSString *dynamicGoodId;
@property (nonatomic, strong) NSArray *goodList;

@property (nonatomic, strong) UIView *goodListView;

@property (nonatomic, strong) NSString *reMemberId;

@property (nonatomic, assign) NSUInteger pageIndex;
@property (nonatomic, assign) BOOL isNetworking;

@end

@implementation DynamicMenuDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.wantsFullScreenLayout = YES;
        self.view.backgroundColor = [UIColor blackColor];
        
        self.commentList = @[];
        self.reMemberId = @"";
        self.dynamicGoodId = @"";
        self.pageIndex = 1;
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(self.view.frame.size.width-PAGE_MARGIN-34, 20.0f, 45.0f, 45.0f);
        [self.closeButton setImage:[UIImage imageNamed:@"close_normal"] forState:UIControlStateNormal];
        [self.closeButton setImage:[UIImage imageNamed:@"close_highlight"] forState:UIControlStateHighlighted];
        [self.closeButton addTarget:self action:@selector(backToMainView) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.closeButton];
        
        self.menuImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT+TOP_HEADER_VIEW_HEIGHT, IMAGE_SIZE_BIG, IMAGE_SIZE_BIG)];
        self.menuImage.image = [UIImage imageNamed:@"default_big.png"];
        [self.view addSubview:self.menuImage];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                       TOP_BAR_HEIGHT,
                                                                       320,
                                                                       self.view.bounds.size.height-TOP_BAR_HEIGHT-55)
                                                      style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.showsVerticalScrollIndicator = NO;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        self.inputView = [[CommentInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-55, 320, 55)];
        [self.inputView.sendButton addTarget:self action:@selector(clickSendButton) forControlEvents:UIControlEventTouchUpInside];
        [self.inputView.atButton addTarget:self action:@selector(clickAtButton) forControlEvents:UIControlEventTouchUpInside];
        self.inputView.textView.placeholder = @"评论";
        [self.view addSubview:self.inputView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.commentList[indexPath.row];
    NSNumber *height = dic[@"cell_height"];
    if (height)
    {
        return height.floatValue;
    }
    
    return 50.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    if (cell == nil)
    {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommentCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.showLight = YES;
    }
    cell.data = self.commentList[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return TOP_HEADER_VIEW_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    
    view.backgroundColor = [UIColor blackColor];
    
    if (self.goodListView)
    {
        [view addSubview:self.goodListView];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    [view addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(TOP_HEADER_VIEW_HEIGHT, 0, 0.5f, TOP_HEADER_VIEW_HEIGHT)];
    lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    [view addSubview:lineView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, TOP_HEADER_VIEW_HEIGHT-0.5f, 320, 0.5f)];
    lineView.backgroundColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    [view addSubview:lineView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, TOP_HEADER_VIEW_HEIGHT, TOP_HEADER_VIEW_HEIGHT);
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 6, 12, 6);
    [button setImage:[UIImage imageNamed:@"big_good_white@2x.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickGood) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, TOP_HEADER_VIEW_HEIGHT, 20)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    label.text = [NSString stringWithFormat:@"%d", self.curGoodCount];
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label];
    self.goodCount = label;
    
    if (self.isGood)
    {
        button.backgroundColor = [UIColor colorWithHtmlColor:@"#008fff"];
        label.textColor = [UIColor colorWithHtmlColor:@"#ffffff"];
    }
    else
    {
        button.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithHtmlColor:@"#5a5a5a"];
    }
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    NSDictionary *data = self.commentList[indexPath.row];
    self.reMemberId = data[@"member_id"];
    if ([self.reMemberId isEqualToString:[UserData sharedUserData].memberId])
    {
        self.reMemberId = @"";
        return;
    }
    self.inputView.textView.placeholder = [NSString stringWithFormat:@"回复%@:", data[@"member_name"]];
    [self.inputView.textView becomeFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.tableFooterView && scrollView.contentOffset.y > scrollView.contentSize.height - 800)
    {
        [self loadMoreData];
    }
}

- (void)loadMoreData
{
    if (self.isNetworking)
    {
        return;
    }
    
    self.pageIndex += 1;
    [self loadCommentData];
}

- (void)clickGood
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    
    NSString *goodsType = self.isGood ? @"0" : @"1";
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"member_menu_image_id":self.data[@"member_menu_image_id"],
                          @"goods_type":goodsType,
                          @"member_menu_image_goods_id":self.dynamicGoodId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/editMenuGoods" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    self.isGood = !self.isGood;
                    
                    [self loadGoodData];
                }
            }
        });
    });
}

- (void)clickAtButton
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFollowUser:) name:FOLLOW_SELECT_NAME object:nil];
    
    FollowSelectViewController *vc = [[FollowSelectViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)clickSendButton
{
    if (![UserData sharedUserData].isLogin)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedLogin" object:nil];
        return;
    }
    
    [self sendComment:self.inputView.textView.text toMember:self.reMemberId];
    self.reMemberId = @"";
    self.inputView.textView.placeholder = @"评论";
    [self.inputView clearContent];
    [self.inputView.textView resignFirstResponder];
}

- (void)backToMainView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setData:(NSDictionary *)data
{
    _data = data;
    
    NSString *photoUrl = [NSString stringWithFormat:@"%@%@", data[@"image_location"], data[@"image_name"]];
    [self.menuImage setImageWithURL:[NSURL URLWithString:photoUrl] placeholderImage:[UIImage imageNamed:@"default_big.png"]];
    
    [self loadGoodData];
    
    self.pageIndex = 1;
    [self loadCommentData];
}

- (void)setCommentList:(NSArray *)commentList
{
    UITextView *tempView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 260, 100)];
    tempView.font = [UIFont systemFontOfSize:THIRD_FONT_SIZE];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *targetFormatter = [[NSDateFormatter alloc] init];
    [targetFormatter setDateFormat:@"MM/dd HH:mm"];
    
    NSMutableArray *list = [NSMutableArray array];
    for (NSDictionary *dic in commentList)
    {
        NSMutableDictionary *comment = [dic mutableCopy];
        
        tempView.text = comment[@"comment_content"];
        CGSize size = [tempView sizeThatFits:CGSizeMake(270, FLT_MAX)];
        if (size.height > 16.0f)
        {
            comment[@"cell_height"] = [NSNumber numberWithFloat:34.0f + size.height];
        }
        
        NSDate *date = [dateFormatter dateFromString:comment[@"comment_date"]];
        if (date)
        {
            comment[@"comment_date"] = [targetFormatter stringFromDate:date];
        }
        
        [list addObject:comment];
    }
    
    _commentList = list;
}

- (void)loadCommentData
{
    self.isNetworking = YES;
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"member_menu_image_id":self.data[@"member_menu_image_id"],
                          @"count":@"10",
                          @"page":[NSString stringWithFormat:@"%d", self.pageIndex]};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getMenuComment" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.isNetworking = NO;
            
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *returnData = [result[@"data"] lastObject];
                    
                    if (self.pageIndex == 1)
                    {
                        self.commentList = returnData[@"comment_list"];
                    }
                    else
                    {
                        self.commentList = [self.commentList arrayByAddingObjectsFromArray:returnData[@"comment_list"]];
                    }
                    
                    [self.tableView reloadData];
                    
                    if ([returnData[@"comment_list"] count] == 10)
                    {
                        // 显示加载更多
                        if (self.tableView.tableFooterView == nil)
                        {
                            UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
                            footView.backgroundColor = [UIColor clearColor];
                            
                            UIImageView *loading = [[UIImageView alloc] initWithFrame:CGRectMake(148, 10, 30, 30)];
                            loading.image = [UIImage imageNamed:@"loading_dark.png"];
                            CABasicAnimation* rotationAnimation;
                            rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                            rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
                            rotationAnimation.duration = 2.0f;
                            rotationAnimation.cumulative = YES;
                            rotationAnimation.repeatCount = HUGE_VALF;
                            [loading.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
                            [footView addSubview:loading];
                            
                            self.tableView.tableFooterView = footView;
                        }
                    }
                    else
                    {
                        self.tableView.tableFooterView = nil;
                    }
                }
            }
        });
    });
}

- (void)sendComment:(NSString *)comment toMember:(NSString *)memberId
{
    if (!comment || comment.length == 0)
    {
        return;
    }
    
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"member_menu_image_id":self.data[@"member_menu_image_id"],
                          @"comment_content":comment,
                          @"comment_type":@"1",
                          @"member_menu_image_comment_id":@"",
                          @"r_member_id":memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/editMenuComment" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    self.pageIndex = 1;
                    [self loadCommentData];
                }
            }
        });
    });
}

- (void)selectFollowUser:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSDictionary *dic = notification.object;
    if (dic == nil)
    {
        return;
    }
    
    NSString *memberName = dic[@"member_name"];
    self.inputView.textView.text = [NSString stringWithFormat:@"%@@%@ ", self.inputView.textView.text, memberName];
    [self.inputView.textView becomeFirstResponder];
}

- (void)loadGoodData
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId,
                          @"member_menu_image_id":self.data[@"member_menu_image_id"],
                          @"count":@"30",
                          @"page":@"1"};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"dynamic/dynamic/getMenuGoods" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *returnData = [result[@"data"] lastObject];
                    NSDictionary *memberGoods = returnData[@"member_goods"];
                    NSString *goodStatus = memberGoods[@"goods_status"];
                    self.dynamicGoodId = memberGoods[@"member_menu_image_goods_id"];
                    self.isGood = [goodStatus isEqualToString:@"1"];
                    NSString *goodsCount = returnData[@"goods_count"];
                    self.curGoodCount = goodsCount.intValue;
                    self.goodCount.text = goodsCount;
                    self.goodList = returnData[@"goods_list"];
                    
                    // 加载动态头像列表
                    [self createDynamicGoodList];
                    [self.tableView reloadData];
                }
            }
        });
    });
}

- (void)createDynamicGoodList
{
    self.goodListView = [[UIView alloc] initWithFrame:CGRectMake(TOP_HEADER_VIEW_HEIGHT,
                                                                 0,
                                                                 320-TOP_HEADER_VIEW_HEIGHT,
                                                                 TOP_HEADER_VIEW_HEIGHT)];
    self.goodListView.backgroundColor = [UIColor clearColor];
    
    for (int i = 0; i < self.goodList.count; i++)
    {
        NSDictionary *dic = self.goodList[i];
        
        RoundHeadView *imageView = [[RoundHeadView alloc] initWithFrame:CGRectMake(5+i*(IMAGE_SIZE_TINY+5), 5, IMAGE_SIZE_TINY, IMAGE_SIZE_TINY)];
        imageView.roundSideWidth = 1.0f;
        
        imageView.headPic = [UIImage imageNamed:@"man_header_small.png"];
        NSString *url = [TFTools getThumbImageUrlOfLacation:dic[@"iconLocation"] andName:dic[@"iconName"]];
        [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:url]
                                                   options:0
                                                  progress:nil
                                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
                                                     if (finished && image)
                                                     {
                                                         imageView.headPic = image;
                                                     }
                                                 }];
        
        [self.goodListView addSubview:imageView];
    }
}

@end
