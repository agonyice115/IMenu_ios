//
//  RegionSelectView.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-3-25.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "RegionSelectView.h"

@interface RegionSelectView () <UIPickerViewDataSource, UIPickerViewDelegate>

/**
 *  @brief 当前选择ID
 */
@property (nonatomic, strong) NSString *currentId;

@property (nonatomic, strong) NSDictionary *filterData;

@property (nonatomic, strong) NSArray *sheng;
@property (nonatomic, strong) NSArray *shi;

@property (nonatomic ,strong) UIPickerView *pickerView;

@end

@implementation RegionSelectView

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

- (void)setCurrentId:(NSString *)currentId withData:(NSDictionary *)data
{
    self.currentId = currentId;
    self.filterData = data;
    
    NSDictionary *dic = self.filterData[@"0"];
    self.sheng = dic[@"children"];
    
    NSDictionary *current = self.filterData[currentId];
    NSString *parentId = current[@"parent"];
    
    [self createShiOfId:parentId];
    [self.pickerView reloadAllComponents];
    
    NSUInteger rowOfSheng = [self.sheng indexOfObject:parentId];
    NSUInteger rowOfShi = [self.shi indexOfObject:currentId];
    [self.pickerView selectRow:rowOfSheng inComponent:0 animated:NO];
    [self.pickerView selectRow:rowOfShi inComponent:1 animated:NO];
}

- (void)createShiOfId:(NSString *)Id
{
    NSDictionary *dic = self.filterData[Id];
    self.shi = dic[@"children"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.sheng.count;
    }
    else
    {
        return self.shi.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSDictionary *dic = self.filterData[self.sheng[row]];
        return dic[@"title"];
    }
    else
    {
        NSDictionary *dic = self.filterData[self.shi[row]];
        return dic[@"title"];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [self createShiOfId:self.sheng[row]];
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:NO];
        self.currentId = self.shi[0];
    }
    else
    {
        self.currentId = self.shi[row];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.delegate)
    {
        [self.delegate onSelectId:self.currentId withData:self.filterData[self.currentId] by:self];
    }
    [self removeFromSuperview];
}

@end
