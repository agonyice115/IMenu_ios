//
//  Networking.m
//  imenu_client_ios
//
//  Created by 李亮 on 13-12-8.
//  Copyright (c) 2013年 西安树萤信息科技有限公司. All rights reserved.
//

#import "Networking.h"
#import "Common.h"
#import "Reachability.h"

#ifdef DEBUG
    #define SERVER_URL @"http://218.244.158.175/imenu_test/app_interface/index.php"
#else
    #define SERVER_URL @"http://www.imenu.so/app_interface/index.php"
#endif

@interface Networking ()

@property (nonatomic, strong) Reachability *internetReachability;

@end

@implementation Networking

+ (Networking *)sharedNetworking
{
    static dispatch_once_t once;
    static id instance;
    
    dispatch_once(&once, ^{
        instance = [[Networking alloc] init];
    });
    
    return instance;
}

- (void)startNetCheck
{
    NSNumber *autoWiFi = [[NSUserDefaults standardUserDefaults] objectForKey:@"AutoWiFi"];
    if (autoWiFi && !autoWiFi.boolValue)
    {
        _isAutoWiFi = NO;
    }
    else
    {
        _isAutoWiFi = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    self.internetReachability = [Reachability reachabilityForInternetConnection];
    [self.internetReachability startNotifier];
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    self.isWiFi = netStatus == ReachableViaWiFi;
}

- (void)reachabilityChanged:(NSNotification *)note
{
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    self.isWiFi = netStatus == ReachableViaWiFi;
}

- (void)setIsAutoWiFi:(BOOL)isAutoWiFi
{
    _isAutoWiFi = isAutoWiFi;
    
    NSNumber *autoWiFi = [NSNumber numberWithBool:isAutoWiFi];
    [[NSUserDefaults standardUserDefaults] setObject:autoWiFi forKey:@"AutoWiFi"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isWiFi
{
    if (self.isAutoWiFi)
    {
        return _isWiFi;
    }
    else
    {
        return YES;
    }
}

+ (NSDictionary *)postData:(NSDictionary *)data withRoute:(NSString *)route withToken:(NSString *)token
{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"=======send========\nroute:%@\ntoken:%@\njsonText:%@", route, token, jsonText);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL]];
    NSString *body = [NSString stringWithFormat:@"route=%@&token=%@&jsonText=%@",
                      route, token, jsonText];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:15];
    [request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (returnData)
    {
        jsonText = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"=======revc========\n%@", jsonText);
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
        return jsonObject;
    }
    
    return nil;
}

+ (NSDictionary *)postData:(NSDictionary *)data withRoute:(NSString *)route withToken:(NSString *)token withImage:(UIImage *)image
{
    static NSString *s_boundary = @"92jjfiej9293jfjdi9lwfjie";

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonText = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"=======send========\nroute:%@\ntoken:%@\njsonText:%@", route, token, jsonText);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:15];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", s_boundary] forHTTPHeaderField:@"Content-Type"];
    NSMutableData *postData = [[NSMutableData alloc] init];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                           s_boundary,
                           @"route",
                           route]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                           s_boundary,
                           @"token",
                           token]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n",
                           s_boundary,
                           @"jsonText",
                           jsonText]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\nContent-Type: image/jpeg\r\n\r\n",
                           s_boundary,
                           @"image",
                           @"pic"]
                          dataUsingEncoding:NSUTF8StringEncoding]];

    [postData appendData:UIImageJPEGRepresentation(image, JPEG_QUALITY)];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", s_boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (returnData)
    {
        jsonText = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        //NSLog(@"=======revc========\n%@", jsonText);
        
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
        return jsonObject;
    }
    
    return nil;
}

@end
