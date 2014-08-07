//
//  IMSegmentedControl.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-2.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMSegmentedControl.h"
#import "IMConfig.h"

/**
 *  圆角半径
 */
#define IM_CORNER_RADIUS 5.0f

/**
 *  边框线宽
 */
#define IM_BORDER_WIDTH 1.0f

/**
 *  排序图像大小
 */
#define IM_SORT_IMAGE_SIZE 12.0f

/**
 *  升序图像
 */
#define IM_ASC_IMAGE @"asc.png"

/**
 *  降序图像
 */
#define IM_DESC_IMAGE @"desc.png"

#pragma mark - IMSegmentedItem 类定义

/**
 *  分段控件项
 */
@interface IMSegmentedItem : UIView

- (void)UIColorChanged;

@property (nonatomic, assign) BOOL isSorted;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL ascending;

@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation IMSegmentedItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.title = [[UILabel alloc] initWithFrame:self.bounds];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.font = [UIFont systemFontOfSize:14.0f];
        [self addSubview:self.title];
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 5)];
        self.imageView.hidden = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)setIsSorted:(BOOL)isSorted
{
    if (isSorted == _isSorted)
    {
        return;
    }
    
    _isSorted = isSorted;
    
    [self autoLayout];
}

- (void)setSelected:(BOOL)selected
{
    // 已经选择，再次选择为改变排序规则
    if (_selected && selected)
    {
        self.ascending = !self.ascending;
    }
    
    _selected = selected;
    
    if (selected)
    {
        self.title.textColor = [IMConfig sharedConfig].fgColor;
        self.backgroundColor = [IMConfig sharedConfig].bgColor;
    }
    else
    {
        self.title.textColor = [IMConfig sharedConfig].bgColor;
        self.backgroundColor = [IMConfig sharedConfig].fgColor;
    }
    
    [self autoLayout];
}

- (void)autoLayout
{
    [self.title sizeToFit];
    
    if (self.selected && self.isSorted)
    {
        self.title.center = CGPointMake((self.bounds.size.width - IM_SORT_IMAGE_SIZE)/2, self.bounds.size.height/2);
        self.imageView.center = CGPointMake((self.bounds.size.width + self.title.bounds.size.width)/2, self.bounds.size.height/2);
        
        if (self.ascending)
        {
            self.imageView.image = [UIImage imageNamed:IM_ASC_IMAGE];
        }
        else
        {
            self.imageView.image = [UIImage imageNamed:IM_DESC_IMAGE];
        }
        self.imageView.hidden = NO;
    }
    else
    {
        self.title.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        self.imageView.hidden = YES;
    }
}

- (void)UIColorChanged
{
    if (self.selected)
    {
        self.title.textColor = [IMConfig sharedConfig].fgColor;
        self.backgroundColor = [IMConfig sharedConfig].bgColor;
    }
    else
    {
        self.title.textColor = [IMConfig sharedConfig].bgColor;
        self.backgroundColor = [IMConfig sharedConfig].fgColor;
    }
}

@end

#pragma mark - IMSegmentedControl 类定义

@interface IMSegmentedControl ()

@property (nonatomic, strong) NSMutableArray *segmentedItems;
@property (nonatomic, strong) NSMutableArray *separates;
@property (nonatomic, assign) CGFloat itemWidth;

@end

@implementation IMSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame withSegmentedItems:@[@"First", @"Second"] atIndex:0];
}

- (id)initWithFrame:(CGRect)frame withSegmentedItems:(NSArray *)items atIndex:(NSUInteger)index
{
    NSAssert([items count] > 1, @"分段控件最少需要2个选项");
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = IM_CORNER_RADIUS;
        self.layer.borderWidth = IM_BORDER_WIDTH;
        self.layer.borderColor = [IMConfig sharedConfig].bgColor.CGColor;
        
        self.segmentedItems = [NSMutableArray array];
        
        NSUInteger count = [items count];
        self.itemWidth = frame.size.width/count;
        for (NSUInteger i = 0; i < count; ++i)
        {
            IMSegmentedItem *item = [[IMSegmentedItem alloc] initWithFrame:CGRectMake(i*self.itemWidth, 0, self.itemWidth, frame.size.height)];
            item.title.text = items[i];
            
            if (i == index)
            {
                item.selected = YES;
            }
            else
            {
                item.selected = NO;
            }
            
            [self addSubview:item];
            [self.segmentedItems addObject:item];
        }
        
        self.separates = [NSMutableArray array];
        
        for (NSUInteger i = 1; i < count; ++i)
        {
            UIView *separate = [[UIView alloc] initWithFrame:CGRectMake(i*self.itemWidth, 0, 1, frame.size.height)];
            separate.backgroundColor = [IMConfig sharedConfig].bgColor;
            [self addSubview:separate];
            [self.separates addObject:separate];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIColorChanged:) name:IM_UICOLOR_CHANGED object:nil];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self addGestureRecognizer:singleTap];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)UIColorChanged:(NSNotification *)notification
{
    self.layer.borderColor = [IMConfig sharedConfig].bgColor.CGColor;
    
    for (IMSegmentedItem *item in self.segmentedItems)
    {
        [item UIColorChanged];
    }
    
    for (UIView *separate in self.separates)
    {
        separate.backgroundColor = [IMConfig sharedConfig].bgColor;
    }
}

- (void)handleTap:(UIGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self];
    NSUInteger index = location.x/self.itemWidth;
    for (NSUInteger i = 0; i < [self.segmentedItems count]; ++i)
    {
        IMSegmentedItem *item = self.segmentedItems[i];
        if (i == index)
        {
            item.selected = YES;
            
            if (self.delegate)
            {
                [self.delegate segmented:self clickSegmentItemAtIndex:index bySort:item.ascending];
            }
        }
        else
        {
            item.selected = NO;
        }
    }
}

- (void)setIsSorted:(BOOL)isSorted
{
    if (isSorted == _isSorted)
    {
        return;
    }
    
    _isSorted = isSorted;
    
    for (IMSegmentedItem *item in self.segmentedItems)
    {
        item.isSorted = isSorted;
    }
}

@end
