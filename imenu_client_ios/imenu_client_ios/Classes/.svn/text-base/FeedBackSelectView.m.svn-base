//
//  FeedBackSelectView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-27.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "FeedBackSelectView.h"
#import "TFTools.h"

@interface FeedBackSelectView () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) int level;
@property (nonatomic, strong) NSString *parentId;
/**
 *  @brief 当前选择ID
 */
@property (nonatomic, strong) NSString *currentId;

@property (nonatomic, strong) NSMutableDictionary *filterData;

@property (nonatomic, strong) NSMutableArray *sheng;
@property (nonatomic, strong) NSMutableArray *shi;

@property (nonatomic ,strong) UIPickerView *pickerView;

@end

@implementation FeedBackSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
        self.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (frame.size.height-216)/2, 320, 20)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"点击此处完成选择";
        label.font = [UIFont systemFontOfSize:15.0f];
        [self addSubview:label];
        
        self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, frame.size.height-216, 320, 216)];
        self.pickerView.backgroundColor = [UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:self.pickerView];
    }
    return self;
}

- (void)setParentId:(NSString *)Id withLevel:(int)level
{
    _level = level;
    _parentId = Id;
    
    [self loadData];
}

- (void)loadData
{
    NSString *filePath = [TFTools getDocumentPathOfFile:@"feedback.plist"];
    NSArray *data = [NSArray arrayWithContentsOfFile:filePath];
    
    self.filterData = [NSMutableDictionary dictionary];
    self.sheng = [NSMutableArray array];
    self.shi = [NSMutableArray array];
    for (NSDictionary *dic in data)
    {
        self.filterData[dic[@"feedback_id"]] = [dic mutableCopy];
        
        NSNumber *level = dic[@"level"];
        if (level.intValue == self.level)
        {
            [self.shi addObject:dic[@"feedback_id"]];
        }
    }
    
    if (self.level == 1)
    {
        self.sheng = self.shi;
    }
    else
    {
        for (NSString *Id in self.shi)
        {
            NSMutableDictionary *dic = self.filterData[Id];
            NSString *parentId = dic[@"parent_id"];
            if ([self.parentId isEqualToString:parentId])
            {
                [self.sheng addObject:Id];
            }
        }
        
        if (self.sheng.count == 0)
        {
            [self.sheng addObject:self.parentId];
        }
    }
    
    self.currentId = self.sheng[0];
    [self.pickerView reloadAllComponents];
    
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sheng.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *dic = self.filterData[self.sheng[row]];
    return dic[@"feedback_name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentId = self.sheng[row];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate)
    {
        NSMutableDictionary *dic = self.filterData[self.currentId];
        [self.delegate onSelectData:dic withLevel:self.level];
    }
    [self removeFromSuperview];
}

@end
