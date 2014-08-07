//
//  ClientConfig.m
//  imenu_client_ios
//
//  Created by 李亮 on 14-1-2.
//  Copyright (c) 2014年 西安树萤信息科技有限公司. All rights reserved.
//

#import "ClientConfig.h"
#import "Networking.h"
#import "TFTools.h"
#import "UserData.h"
#import "Common.h"

@interface ClientConfig () <UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *configVersion;
@property (nonatomic, strong) NSMutableDictionary *sharedString;
@property (nonatomic, strong) NSString *currentVersion;

@property (nonatomic, strong) NSMutableArray *services;
@property (nonatomic, strong) NSMutableArray *environments;
@property (nonatomic, strong) NSArray *tastes;
@property (nonatomic, strong) NSArray *aboutInfo;

@end

static ClientConfig *s_ClientConfig;

@implementation ClientConfig

+ (ClientConfig *)sharedConfig
{
    @synchronized(self)
    {
        if(s_ClientConfig == nil)
        {
            s_ClientConfig = [[self alloc] init];
            s_ClientConfig.currentVersion = @"1.1";
            [s_ClientConfig loadClientConfig];
            [s_ClientConfig checkClientConfig];
        }
    }
    return s_ClientConfig;
}

- (void)loadClientConfig
{
    NSString *fileName = [TFTools getDocumentPathOfFile:@"ConfigVersion.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.configVersion = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    }
    else
    {
        self.configVersion = [@{CONFIG_VERSION_NAME_REGION:@"-1",
                                CONFIG_VERSION_NAME_CATEGORY:@"-1",
                                CONFIG_VERSION_NAME_ENVIRONMENT:@"-1",
                                CONFIG_VERSION_NAME_SERVICE:@"-1",
                                CONFIG_VERSION_NAME_MENU_UNIT:@"-1",
                                CONFIG_VERSION_NAME_MENU_TASTE:@"-1",
                                CONFIG_VERSION_NAME_AREA_CODE:@"-1",
                                CONFIG_VERSION_NAME_SHARE_MENU:@"-1",
                                CONFIG_VERSION_NAME_SHARE_STORE:@"-1",
                                CONFIG_VERSION_NAME_SHARE_MEMBER:@"-1",
                                CONFIG_VERSION_NAME_SHARE_DYNAMIC:@"-1",
                                CONFIG_VERSION_NAME_SKIN:@"-1",
                                CONFIG_VERSION_NAME_FEEDBACK:@"-1",
                                CONFIG_VERSION_NAME_ABOUT_INFO:@"-1"} mutableCopy];
    }
    
    fileName = [TFTools getDocumentPathOfFile:@"SharedString.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.sharedString = [NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    }
    else
    {
        self.sharedString = [NSMutableDictionary dictionary];
    }
    
    fileName = [TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_REGION stringByAppendingPathExtension:@"plist"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.regionFilterData = [NSDictionary dictionaryWithContentsOfFile:fileName];
    }
    else
    {
        self.regionFilterData = [NSDictionary dictionary];
    }
    
    fileName = [TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_SERVICE stringByAppendingPathExtension:@"plist"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.services = [NSMutableArray arrayWithContentsOfFile:fileName];
    }
    else
    {
        self.services = [NSMutableArray array];
    }
    
    fileName = [TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_ENVIRONMENT stringByAppendingPathExtension:@"plist"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.environments = [NSMutableArray arrayWithContentsOfFile:fileName];
    }
    else
    {
        self.environments = [NSMutableArray array];
    }
    
    fileName = [TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_ABOUT_INFO stringByAppendingPathExtension:@"plist"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileName])
    {
        self.aboutInfo = [NSArray arrayWithContentsOfFile:fileName];
    }
    else
    {
        self.aboutInfo = [NSArray array];
    }
}

- (void)checkClientConfig
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:@"tokenString"];
    if (!tokenString)
    {
        tokenString = @"";
    }
    
    NSMutableDictionary *dic = [self.configVersion mutableCopy];
    dic[@"device_type"] = @"10";
    dic[CONFIG_VERSION_NAME_VERSION_IOS] = self.currentVersion;
    dic[CONFIG_VERSION_NAME_MOBILE_TOKEN] = tokenString;
    
    dispatch_queue_t downloadQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(downloadQueue, ^{
        NSDictionary *result = [Networking postData:dic withRoute:@"setting/client_config/checkClientConfig" withToken:@""];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result)
            {
                NSString *errorString = result[@"error"];
                if ([errorString length] == 0)
                {
                    NSDictionary *resultData = result[@"data"];
                    [self parseConfigData:resultData[@"config_list"]];
                }
            }
            else
            {
                NSString *fileName = [[NSBundle mainBundle]pathForResource:@"client_config" ofType:@"json"];
                NSData *data = [NSData dataWithContentsOfFile:fileName];
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSDictionary *resultData = jsonObject[@"data"];
                [self parseConfigData:resultData[@"config_list"]];
            }
            
            if (self.updateVersion)
            {
                NSLog(@"强制更新");
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"微点有了更好的新版本，请您立即更新获得更好体验！" delegate:self cancelButtonTitle:@"更新" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else
            {
                [[UserData sharedUserData] loadingUserData];
            }
        });
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 更新
    NSString *url = [NSString stringWithFormat:@"%@%@", @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?&id=", APPID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)parseConfigData:(NSArray *)configData
{
    BOOL isVersionChange = NO;
    BOOL isSharedChange = NO;
    for (NSDictionary *dic in configData)
    {
        NSString *key = dic[@"key"];
        NSString *version = dic[@"value"];
        id data = dic[@"data"];
        
        if ([version isEqualToString:self.configVersion[key]])
        {
            continue;
        }
        
        if ([key isEqualToString:CONFIG_VERSION_NAME_VERSION_IOS])
        {
            if (version.floatValue > self.currentVersion.floatValue)
            {
                // 有新的版本，需要更新
                NSLog(@"发现新版本 : %@", version);
                self.updateVersion = YES;
                continue;
            }
        }
        
        if (data)
        {
            if ([data isKindOfClass:[NSDictionary class]])
            {
                isSharedChange = YES;
                self.sharedString[key] = data;
            }
            else if ([data isKindOfClass:[NSArray class]])
            {
                NSString *fileName = [[TFTools getDocumentPathOfFile:key] stringByAppendingPathExtension:@"plist"];
                if ([key isEqualToString:CONFIG_VERSION_NAME_REGION])
                {
                    self.regionFilterData = [self analysisRegionData:data];
                    [self.regionFilterData writeToFile:fileName atomically:YES];
                }
                else if ([key isEqualToString:CONFIG_VERSION_NAME_CATEGORY])
                {
                    NSDictionary *regionData = [self analysisCategoryData:data];
                    [regionData writeToFile:fileName atomically:YES];
                }
                else if ([key isEqualToString:CONFIG_VERSION_NAME_ABOUT_INFO])
                {
                    self.aboutInfo = data;
                    [data writeToFile:fileName atomically:YES];
                }
                else if ([key isEqualToString:CONFIG_VERSION_NAME_SERVICE])
                {
                    self.services = [data mutableCopy];
                    [self.services sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        NSString *sort1 = obj1[@"sort_order"];
                        NSString *sort2 = obj2[@"sort_order"];
                        if (sort1.intValue < sort2.intValue)
                        {
                            return NSOrderedAscending;
                        }
                        else if (sort1.intValue == sort2.intValue)
                        {
                            return NSOrderedSame;
                        }
                        else
                        {
                            return NSOrderedDescending;
                        }
                    }];
                    [self.services writeToFile:fileName atomically:YES];
                }
                else if ([key isEqualToString:CONFIG_VERSION_NAME_ENVIRONMENT])
                {
                    self.environments = [data mutableCopy];
                    [self.environments sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                        NSString *sort1 = obj1[@"sort_order"];
                        NSString *sort2 = obj2[@"sort_order"];
                        if (sort1.intValue < sort2.intValue)
                        {
                            return NSOrderedAscending;
                        }
                        else if (sort1.intValue == sort2.intValue)
                        {
                            return NSOrderedSame;
                        }
                        else
                        {
                            return NSOrderedDescending;
                        }
                    }];
                    [self.environments writeToFile:fileName atomically:YES];
                }
                else
                {
                    [data writeToFile:fileName atomically:YES];
                }
            }
            else
            {
                continue;
            }
            
            isVersionChange = YES;
            self.configVersion[key] = version;
        }
    }
    
    if (isVersionChange)
    {
        NSString *fileName = [TFTools getDocumentPathOfFile:@"ConfigVersion.plist"];
        [self.configVersion writeToFile:fileName atomically:YES];
    }
    
    if (isSharedChange)
    {
        NSString *fileName = [TFTools getDocumentPathOfFile:@"SharedString.plist"];
        [self.sharedString writeToFile:fileName atomically:YES];
    }
}

- (NSDictionary *)analysisCategoryData:(NSArray *)data
{
    NSMutableDictionary *regionData = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in data)
    {
        NSMutableDictionary *filterData = [NSMutableDictionary dictionary];
        filterData[@"id"] = dic[@"category_id"];
        filterData[@"title"] = dic[@"category_name"];
        filterData[@"image"] = dic[@"category_image"];
        filterData[@"sort"] = dic[@"sort_order"];
        filterData[@"parent"] = dic[@"parent_id"];
        filterData[@"has_all"] = @"yes";
        
        regionData[filterData[@"id"]] = filterData;
    }
    
    NSMutableDictionary *top = [NSMutableDictionary dictionary];
    top[@"has_all"] = @"yes";
    top[@"title"] = @"全部";
    top[@"id"] = @"0";
    regionData[@"0"] = top;
    
    return [self generateFilterChildren:regionData];
}

- (NSDictionary *)analysisRegionData:(NSArray *)data
{
    NSMutableDictionary *regionData = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in data)
    {
        NSString *level = dic[@"level"];
        
        NSMutableDictionary *filterData = [NSMutableDictionary dictionary];
        filterData[@"id"] = dic[@"region_id"];
        filterData[@"title"] = dic[@"region_name"];
        filterData[@"image"] = dic[@"region_image"];
        filterData[@"sort"] = dic[@"sort_order"];
        filterData[@"parent"] = dic[@"parent_id"];
        filterData[@"level"] = dic[@"level"];
        filterData[@"is_open"] = dic[@"is_open"];
        if (level.intValue == 1)
        {
            filterData[@"has_all"] = @"no";
        }
        else
        {
            filterData[@"has_all"] = @"yes";
        }
        
        regionData[filterData[@"id"]] = filterData;
    }
    
    NSMutableDictionary *top = [NSMutableDictionary dictionary];
    top[@"has_all"] = @"no";
    top[@"title"] = @"全部";
    top[@"id"] = @"0";
    regionData[@"0"] = top;
    
    return [self generateFilterChildren:regionData];
}

- (NSDictionary *)generateFilterChildren:(NSMutableDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableDictionary *dic = obj;
        NSString *parentId = dic[@"parent"];
        
        if (parentId)
        {
            NSMutableDictionary * parent = data[parentId];
            if (parent == nil)
            {
                parent = data[@"0"];
                dic[@"parent"] = @"0";
            }
            
            NSMutableArray *children = parent[@"children"];
            if (children == nil)
            {
                children = [NSMutableArray array];
                parent[@"children"] = children;
            }
            [children addObject:dic[@"id"]];
        }
    }];
    
    return [self sortFilterChildren:data];
}

- (NSDictionary *)sortFilterChildren:(NSMutableDictionary *)data
{
    [data enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableDictionary *dic = obj;
        NSMutableArray *children = dic[@"children"];
        if (children)
        {
            [children sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                NSMutableDictionary *filterData1 = data[obj1];
                NSMutableDictionary *filterData2 = data[obj2];
                NSString *sort1 = filterData1[@"sort"];
                NSString *sort2 = filterData2[@"sort"];
                if (sort1.intValue < sort2.intValue)
                {
                    return NSOrderedAscending;
                }
                else if (sort1.intValue == sort2.intValue)
                {
                    return NSOrderedSame;
                }
                else
                {
                    return NSOrderedDescending;
                }
            }];
        }
    }];
    
    return data;
}

- (NSArray *)getServiceList:(NSArray *)list
{
    if (list == nil || [list count] == 0)
    {
        return nil;
    }
    
    NSMutableArray *returnList = [NSMutableArray array];
    
    for (int i = 0; i < [self.services count]; i++)
    {
        NSDictionary *service = self.services[i];
        for (NSDictionary *dic in list)
        {
            if ([service[@"service_id"] isEqualToString:dic[@"service_id"]])
            {
                [returnList addObject:service];
            }
        }
    }
    
    return returnList;
}

- (NSArray *)getEnvironmentList:(NSArray *)list
{
    if (list == nil || [list count] == 0)
    {
        return nil;
    }
    
    NSMutableArray *returnList = [NSMutableArray array];
    
    for (int i = 0; i < [self.environments count]; i++)
    {
        NSDictionary *environment = self.environments[i];
        for (NSDictionary *dic in list)
        {
            if ([environment[@"environment_id"] isEqualToString:dic[@"environment_id"]])
            {
                [returnList addObject:environment];
            }
        }
    }
    
    return returnList;
}

- (NSString *)getMenuTasteUrlById:(NSString *)menuTasteId
{
    if (menuTasteId == nil || [menuTasteId length] == 0)
    {
        return @"";
    }
    
    if (self.tastes == nil)
    {
        self.tastes = [NSArray arrayWithContentsOfFile:[TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_MENU_TASTE stringByAppendingPathExtension:@"plist"]]];
    }
    
    for (NSDictionary *dic in self.tastes)
    {
        if ([menuTasteId isEqualToString:dic[@"menu_taste_id"]])
        {
            return dic[@"menu_taste_image"];
        }
    }
    
    return @"";
}

- (NSDictionary *)getShareStringWithName:(NSString *)name andId:(NSString *)Id from:(NSString *)key
{
    NSDictionary *share = self.sharedString[key];
    NSString *content = share[@"content"];
    content = [content stringByReplacingOccurrencesOfString:@"{0}" withString:name];
    content = [content stringByReplacingOccurrencesOfString:@"{1}" withString:Id];
    NSString *link = share[@"link"];
    link = [link stringByReplacingOccurrencesOfString:@"{1}" withString:Id];
    return @{@"title":share[@"title"],
             @"description":share[@"description"],
             @"content":content,
             @"link":link};
}

- (NSDictionary *)getShareStringWithName:(NSString *)name andId:(NSString *)Id shopName:(NSString *)shopName
{
    NSDictionary *share = self.sharedString[@"share_dynamic"];
    NSString *content = share[@"content"];
    content = [content stringByReplacingOccurrencesOfString:@"{0}" withString:name];
    content = [content stringByReplacingOccurrencesOfString:@"{1}" withString:shopName];
    content = [content stringByReplacingOccurrencesOfString:@"{2}" withString:Id];
    NSString *link = share[@"link"];
    link = [link stringByReplacingOccurrencesOfString:@"{2}" withString:Id];
    return @{@"title":share[@"title"],
             @"description":share[@"description"],
             @"content":content,
             @"link":link};
}

- (NSString *)getRegionStringById:(NSString *)regionId
{
    if (!regionId || [regionId isEqualToString:@"0"])
    {
        return @"请选择";
    }
    NSDictionary *dic = self.regionFilterData[regionId];
    NSString *parentId = dic[@"parent"];
    NSDictionary *parent = self.regionFilterData[parentId];
    return [NSString stringWithFormat:@"%@/%@", parent[@"title"], dic[@"title"]];
}

- (NSString *)getGuanwang
{
    for (NSDictionary *dic in self.aboutInfo)
    {
        if ([dic[@"key"] isEqualToString:@"website"])
        {
            return dic[@"value"];
        }
    }
    
    return @"";
}

- (NSString *)getWechat
{
    for (NSDictionary *dic in self.aboutInfo)
    {
        if ([dic[@"key"] isEqualToString:@"wechat"])
        {
            return dic[@"value"];
        }
    }
    
    return @"";
}

@end
