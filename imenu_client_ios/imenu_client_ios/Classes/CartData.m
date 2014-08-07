//
//  CartData.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-19.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "CartData.h"
#import "UserData.h"
#import "Networking.h"

static CartData *s_CartData;

@implementation CartData

+ (CartData *)sharedCartData
{
    @synchronized(self)
    {
        if(s_CartData == nil)
        {
            s_CartData = [[self alloc] init];
        }
    }
    return s_CartData;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _peopleCount = 1;
        self.cartList = [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginOK:) name:@"userLoginOK" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogoutOK:) name:@"userLogoutOK" object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userLoginOK:(NSNotification *)notification
{
    [self loadData];
}

- (void)userLogoutOK:(NSNotification *)notification
{
    [self cleanData];
}

- (void)addMenu:(NSDictionary *)menuData
{
    NSString *menuId = menuData[@"menu_id"];
    for (NSMutableDictionary *dic in self.cartList)
    {
        if ([menuId isEqualToString:dic[@"menu_id"]])
        {
            return;
        }
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"menu_id"] = menuData[@"menu_id"];
    dic[@"menu_name"] = menuData[@"menu_name"];
    dic[@"menu_price"] = menuData[@"menu_price"];
    //dic[@"menu_taste_id"] = menuData[@"menu_taste_id"];
    dic[@"menu_count"] = @"1";
    [self.cartList addObject:dic];
    
    NSString *menuPrice = dic[@"menu_price"];
    self.totalPrice += menuPrice.floatValue;
    
    [self sendNotify];
}

- (void)removeMenu:(NSDictionary *)menuData
{
    NSString *menuId = menuData[@"menu_id"];
    for (NSMutableDictionary *dic in self.cartList)
    {
        if ([menuId isEqualToString:dic[@"menu_id"]])
        {
            NSString *menuCount = dic[@"menu_count"];
            NSString *menuPrice = dic[@"menu_price"];
            self.totalPrice -= menuPrice.floatValue * menuCount.intValue;
            
            [self.cartList removeObject:dic];
            
            [self sendNotify];
            
            break;
        }
    }
}

- (void)addMenuCount:(NSString *)menuId
{
    for (NSMutableDictionary *dic in self.cartList)
    {
        if ([menuId isEqualToString:dic[@"menu_id"]])
        {
            NSString *menuCount = dic[@"menu_count"];
            dic[@"menu_count"] = [NSString stringWithFormat:@"%d", menuCount.intValue+1];
            
            NSString *menuPrice = dic[@"menu_price"];
            self.totalPrice += menuPrice.floatValue;
            
            [self sendNotify];
            
            break;
        }
    }
}

- (void)redMenuCount:(NSString *)menuId
{
    for (NSMutableDictionary *dic in self.cartList)
    {
        if ([menuId isEqualToString:dic[@"menu_id"]])
        {
            NSString *menuCount = dic[@"menu_count"];
            if (menuCount.intValue > 0)
            {
                dic[@"menu_count"] = [NSString stringWithFormat:@"%d", menuCount.intValue-1];
                
                NSString *menuPrice = dic[@"menu_price"];
                self.totalPrice -= menuPrice.floatValue;
                
                [self sendNotify];
            }
            
            break;
        }
    }
}

- (NSUInteger)menuCount
{
    NSUInteger count = 0;
    for (NSMutableDictionary *dic in self.cartList)
    {
        NSString *menuCount = dic[@"menu_count"];
        if (menuCount.intValue > 0)
        {
            count += 1;
        }
    }
    
    return count;
}

- (BOOL)isOrder:(NSString *)menuId
{
    for (NSMutableDictionary *dic in self.cartList)
    {
        if ([menuId isEqualToString:dic[@"menu_id"]])
        {
            return YES;
        }
    }
    
    return NO;
}

- (void)setPeopleCount:(NSUInteger)peopleCount
{
    _peopleCount = peopleCount;
    
    [self sendNotify];
}

- (void)setStoreData:(NSDictionary *)storeData
{
    NSString *storeId = storeData[@"store_id"];
    
    if ([self.storeId isEqualToString:storeId])
    {
        return;
    }
    
    [self cleanData];
    self.storeId = storeId;
    _storeData = storeData;
}

- (void)loadData
{
    NSDictionary *dic = @{@"member_id":[UserData sharedUserData].memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"order/order/getCart" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    if (resultData && [resultData isKindOfClass:[NSDictionary class]])
                    {
                        _peopleCount = ((NSString *)resultData[@"people"]).intValue;
                        self.totalPrice = ((NSString *)resultData[@"total"]).floatValue;
                        self.cartList = [NSMutableArray array];
                        for (NSDictionary *dic in resultData[@"menu_list"])
                        {
                            [self.cartList addObject:[dic mutableCopy]];
                        }
                        _storeData = resultData[@"store_info"];
                        self.storeId = self.storeData[@"store_id"];
                        self.createDate = resultData[@"create_date"];
                        self.modifyDate = resultData[@"modify_date"];
                        
                        [self changeDateFormat];
                        
                        [self sendNotify];
                        self.dataChanged = NO;
                    }
                }
            }
        });
    });
}

- (void)saveData
{
    if (!self.dataChanged)
    {
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"member_id"] = [UserData sharedUserData].memberId;
    if (self.storeId)
    {
        dic[@"operator_status"] = @"1";
        dic[@"store_id"] = self.storeId;
        dic[@"people"] = [NSString stringWithFormat:@"%d", self.peopleCount];
        dic[@"total"] = [NSString stringWithFormat:@"%.2f", self.totalPrice];
        NSMutableArray *menuList = [NSMutableArray array];
        for (NSDictionary *menu in self.cartList)
        {
            NSString *menuCount = menu[@"menu_count"];
            if (menuCount.intValue > 0)
            {
                [menuList addObject:@{@"menu_id":menu[@"menu_id"],
                                      @"menu_count":menu[@"menu_count"]}];
            }
        }
        dic[@"menu_list"] = menuList;
    }
    else
    {
        dic[@"operator_status"] = @"2";
        dic[@"store_id"] = @"";
        dic[@"people"] = @"";
        dic[@"total"] = @"";
        dic[@"menu_list"] = @"";
    }
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"order/order/editCart" withToken:[UserData sharedUserData].token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    if (resultData && [resultData isKindOfClass:[NSDictionary class]])
                    {
                        _peopleCount = ((NSString *)resultData[@"people"]).intValue;
                        self.totalPrice = ((NSString *)resultData[@"total"]).floatValue;
                        self.cartList = [NSMutableArray array];
                        for (NSDictionary *dic in resultData[@"menu_list"])
                        {
                            [self.cartList addObject:[dic mutableCopy]];
                        }
                        self.storeData = resultData[@"store_info"];
                        self.createDate = resultData[@"create_date"];
                        self.modifyDate = resultData[@"modify_date"];
                        
                        [self changeDateFormat];
                        
                        self.dataChanged = NO;
                        [[NSNotificationCenter defaultCenter] postNotificationName:CART_DATA_SAVED object:nil];
                        return;
                    }
                }
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:CART_DATA_SAVED_ERROR object:nil];
        });
    });
}

- (void)changeDateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormatter dateFromString:self.createDate];
    self.createDate = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
    
    date = [dateFormatter dateFromString:self.modifyDate];
    self.modifyDate = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
}

- (void)cleanData
{
    _storeData = nil;
    self.storeId = nil;
    
    _peopleCount = 0;
    self.totalPrice = 0.0f;
    self.cartList = [NSMutableArray array];
    
    [self sendNotify];
}

- (void)sendNotify
{
    self.dataChanged = YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:CART_DATA_CHANGED object:nil];
}

@end
