//
//  UserData.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "UserData.h"
#import "Networking.h"

static UserData *s_UserData;

@interface UserData () <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *locationRegionId;

@end

@implementation UserData

+ (UserData *)sharedUserData
{
    @synchronized(self)
    {
        if(s_UserData == nil)
        {
            s_UserData = [[self alloc] init];
            [s_UserData loadUserData];
        }
    }
    return s_UserData;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    CLLocationCoordinate2D userLocation = currentLocation.coordinate;
    
    _userCoordinate = userLocation;
    
    _longitude = [NSString stringWithFormat:@"%.6f", userLocation.longitude];
    _latitude = [NSString stringWithFormat:@"%.6f", userLocation.latitude];
    
    [self.locationManager stopUpdatingLocation];
    
    [self checkUserLocation];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationUpdating" object:nil];
    
    [self performSelector:@selector(startUpdatingLocation) withObject:nil afterDelay:60.0f];
}

- (void)startUpdatingLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)checkUserLocation
{
    NSDictionary *data = @{@"longitude_num":self.longitude,
                           @"latitude_num":self.latitude};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:data withRoute:@"base/region/getRegionByPosition" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    NSString *regionId = resultData[@"region_id"];
                    
                    if (regionId == nil || regionId.length == 0)
                    {
                        return;
                    }
                    
                    if (!self.locationRegionId || ![self.locationRegionId isEqualToString:regionId])
                    {
                        // 提示切换
                        if (self.shopRegionId && ![regionId isEqualToString:self.shopRegionId])
                        {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"定位到您当前所在区域不是常用区域，是否切换？" delegate:self cancelButtonTitle:@"暂不切换" otherButtonTitles:@"立即切换", nil];
                            [alert show];
                        }
                    }
                    
                    if (!self.shopRegionId)
                    {
                        _shopRegionId = regionId;
                        [[NSUserDefaults standardUserDefaults] setObject:_shopRegionId forKey:@"_shopRegionId"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                    }
                    
                    self.locationRegionId = regionId;
                }
            }
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        _shopRegionId = self.locationRegionId;
        [[NSUserDefaults standardUserDefaults] setObject:_shopRegionId forKey:@"_shopRegionId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShopRegionIdChanged" object:nil];
    }
}

- (void)loadUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _memberId = [defaults objectForKey:@"memberId"] == nil ? @"" : [defaults objectForKey:@"memberId"];
    _token = [defaults objectForKey:@"token"] == nil ? @"" : [defaults objectForKey:@"token"];
    
    _isLogin = NO;
    
    _longitude = @"0";
    _latitude = @"0";
    
    _regionId = @"0";
    
    _shopRegionId = [[NSUserDefaults standardUserDefaults] objectForKey:@"_shopRegionId"];
    if (_shopRegionId && _shopRegionId.length == 0) {
        _shopRegionId = nil;
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
}

- (void)saveUserData
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.memberId forKey:@"memberId"];
    [defaults setObject:self.token forKey:@"token"];
    [defaults synchronize];
}

- (void)loginUserWithData:(NSDictionary *)data
{
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:data withRoute:@"member/member/login" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    [self setUserDataFromDictionary:resultData];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loginUserOK" object:nil userInfo:result];
        });
    });
}

- (void)resetUserPasswordWithData:(NSDictionary *)data
{
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:data withRoute:@"member/member/resetPassword" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    [self setUserDataFromDictionary:resultData];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetUserPasswordOK" object:nil userInfo:result];
        });
    });
}

- (void)registerUserWithData:(NSDictionary *)data
{
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:data withRoute:@"member/member/registMember" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    [self setUserDataFromDictionary:resultData];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"registerUserOK" object:nil userInfo:result];
        });
    });
}

- (void)loadingUserData
{
    if ([self.memberId length] == 0 || [self.token length] == 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingUserDataOK" object:nil];
        [self startUpdatingLocation];
        return;
    }
    
    NSDictionary *dic = @{@"memberId":self.memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"member/member/loginWithToken" withToken:self.token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _memberId = @"";
            _token = @"";
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    [self setUserDataFromDictionary:resultData];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loadingUserDataOK" object:nil];
            [self startUpdatingLocation];
        });
    });
}

- (void)setUserDataFromDictionary:(NSDictionary *)data
{
    id memberIdObj = data[@"memberId"];
    if (memberIdObj != nil)
    {
        if ([memberIdObj isKindOfClass:[NSString class]])
        {
            _memberId = memberIdObj;
        }
        else if ([memberIdObj isKindOfClass:[NSNumber class]])
        {
            NSNumber *memberIdNumber = memberIdObj;
            _memberId = [memberIdNumber stringValue];
        }
        else
        {
            // 都不是，问题大了
            _isLogin = NO;
            return;
        }
    }
    _memberName = data[@"memberName"] == nil ? _memberName : data[@"memberName"];
    _memberSignature = data[@"signature"] == nil ? _memberSignature : data[@"signature"];
    _token = data[@"token"] == nil ? _token : data[@"token"];
    _sex = data[@"sex"] == nil ? _sex : data[@"sex"];
    _areaCode = data[@"areaCode"] == nil ? _areaCode : data[@"areaCode"];
    _mobile = data[@"mobile"] == nil ? _mobile : data[@"mobile"];
    _realname = data[@"realname"] == nil ? _realname : data[@"realname"];
    _birthday = data[@"birthday"] == nil ? _birthday : [data[@"birthday"] substringToIndex:10];
    _email = data[@"email"] == nil ? _email : data[@"email"];
    _regionId = data[@"regionId"] == nil ? _regionId : data[@"regionId"];
    
    _iconLocation = data[@"iconLocation"] == nil ? _iconLocation : data[@"iconLocation"];
    _iconName = data[@"iconName"] == nil ? _iconName : data[@"iconName"];
    _dynamicLocation = data[@"dynamicLocation"] == nil ? _dynamicLocation : data[@"dynamicLocation"];
    _dynamicName = data[@"dynamicName"] == nil ? _dynamicName : data[@"dynamicName"];
    
    _isLogin = YES;
    
    [self saveUserData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoginOK" object:nil];
}

- (void)editUserInfo:(NSDictionary *)data
{
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:data withRoute:@"member/member/editMemberInfo" withToken:self.token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    [self setUserDataFromDictionary:data];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"editMemberInfoOK" object:nil userInfo:result];
        });
    });
}

- (void)logoutUser
{
    NSDictionary *dic = @{@"memberId":self.memberId};
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"member/member/logout" withToken:self.token];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    _isLogin = NO;
                    
                    _memberId = @"";
                    _token = @"";
                    
                    _memberName = @"";
                    _memberSignature = @"";
                    _sex = @"";
                    _areaCode = @"";
                    _mobile = @"";
                    _realname = @"";
                    _birthday = @"";
                    _email = @"";
                    _regionId = @"0";
                    
                    _iconLocation = @"";
                    _iconName = @"";
                    _dynamicLocation = @"";
                    _dynamicName = @"";
                    
                    [self saveUserData];
                }
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userLogoutOK" object:nil userInfo:result];
        });
    });
}

@end
