//
//  IMConfig.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-2.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "IMConfig.h"
#import "UIColor+HtmlColor.h"
#import "TFTools.h"
#import "ClientConfig.h"

static IMConfig *s_IMConfig;

@interface IMConfig ()

@property (nonatomic, strong) NSString *defaultColor;
@property (nonatomic, strong) NSString *manColor;
@property (nonatomic, strong) NSString *womanColor;

@end

@implementation IMConfig

+ (IMConfig *)sharedConfig
{
    @synchronized(self)
    {
        if(s_IMConfig == nil)
        {
            s_IMConfig = [[self alloc] init];
            [s_IMConfig loadConfigData];
        }
    }
    return s_IMConfig;
}

- (void)loadConfigData
{
    NSArray *skinData = [NSArray arrayWithContentsOfFile:[TFTools getDocumentPathOfFile:[CONFIG_VERSION_NAME_SKIN stringByAppendingPathExtension:@"plist"]]];
    for (NSDictionary *data in skinData)
    {
        NSString *defaultValue = data[@"default"];
        if (defaultValue.intValue == 1)
        {
            self.defaultColor = data[@"client_skin_value"];
        }
        
        NSString *sexValue = data[@"sex"];
        if (sexValue.intValue == 1)
        {
            self.manColor = data[@"client_skin_value"];
        }
        else if (sexValue.intValue == 2)
        {
            self.womanColor = data[@"client_skin_value"];
        }
    }
    if (self.defaultColor == nil)
    {
        self.defaultColor = @"#187db3";
    }
    if (self.manColor == nil)
    {
        self.manColor = @"#434a54";
    }
    if (self.womanColor == nil)
    {
        self.womanColor = @"#789262";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _bgColorString = [defaults objectForKey:@"skinColor"];
    if (_bgColorString == nil)
    {
        _bgColorString = self.defaultColor;
    }
    _fgColor = [UIColor whiteColor];
    _bgColor = [UIColor colorWithHtmlColor:_bgColorString];
}

- (void)setBgColorString:(NSString *)bgColorString
{
    _bgColor = [UIColor colorWithHtmlColor:bgColorString];
    _bgColorString = bgColorString;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:bgColorString forKey:@"skinColor"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_UICOLOR_CHANGED object:nil];
}

- (void)setSexColor:(NSString *)sex
{
    if (sex.intValue == 1)
    {
        self.bgColorString = self.manColor;
    }
    else if (sex.intValue == 2)
    {
        self.bgColorString = self.womanColor;
    }
    else
    {
        self.bgColorString = self.defaultColor;
    }
}

@end
