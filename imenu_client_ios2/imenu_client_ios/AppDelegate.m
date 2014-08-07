//
//  AppDelegate.m
//  imenu_client_ios

//

#import "AppDelegate.h"
#import "IMNavigationController.h"
#import "LoadingViewController.h"
#import "NewUserViewController.h"
#import "ShopViewController.h"
#import "CartData.h"
#import "Flurry.h"
#import "BMapKit.h"
#import <ShareSDK/ShareSDK.h>
#import <RennSDK/RennSDK.h>
#import "WXApi.h"
#import "IMLoadingView.h"
#import "AlixLibService.h"

@interface AppDelegate ()

@property (nonatomic, strong) BMKMapManager *mapManager;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"6BB7W4NZFW6D3HCGX4CF"];
    
    [AlixLibService exitFullScreen];
    
    [ShareSDK registerApp:@"16422fe67edc"];
    
    [ShareSDK connectSinaWeiboWithAppKey:@"4012589497"
                               appSecret:@"cad1412fd89be70722de86337a571a54"
                             redirectUri:@"http://192.168.100.100"];
    
    [ShareSDK connectRenRenWithAppId:@"245510"
                              appKey:@"40376e9f727648cbb209d1f924cc6652"
                           appSecret:@"775d82210d6a4d53b9fd162176830b88"
                   renrenClientClass:[RennClient class]];
    
    [ShareSDK connectWeChatWithAppId:@"wx76e86073a6e91077"
                           wechatCls:[WXApi class]];
    
    self.mapManager = [[BMKMapManager alloc] init];
    if ([self.mapManager start:@"MOKcYuCmcc00sinBf7b2FbcB" generalDelegate:nil])
    {
        NSLog(@"百度地图SDK加载成功");
    }
    else
    {
        NSLog(@"！！！！！！！百度地图SDK加载失败！！！！！！！！");
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *tokenString = [defaults objectForKey:@"tokenString"];
    if (!tokenString || [tokenString length] == 0)
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"NewUser"])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingUserDataOK:) name:@"loadingUserDataOK" object:nil];
        
        LoadingViewController *rootViewController = [[LoadingViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = rootViewController;
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchRootViewController) name:@"newUserStart" object:nil];
        NewUserViewController *rootViewController = [[NewUserViewController alloc] initWithNibName:nil bundle:nil];
        self.window.rootViewController = rootViewController;
    }
    
    [IMLoadingView sharedLoadingView].window = self.window;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *tokenString = [[[[deviceToken description]
                               stringByReplacingOccurrencesOfString:@"<" withString:@""]
                              stringByReplacingOccurrencesOfString:@">" withString:@""]
                             stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tokenString && [tokenString length] > 0)
    {
        NSLog(@"设备令牌: %@", tokenString);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tokenString forKey:@"tokenString"];
        [defaults synchronize];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"获取令牌失败：%@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[CartData sharedCartData] saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application  handleOpenURL:(NSURL *)url
{
    NSLog(@"========handleOpenURL======\n%@", url);
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
	NSString * query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"========handleOpenURL======\n%@", query);
    
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)loadingUserDataOK:(NSNotification *)notification
{
    [self performSelector:@selector(switchRootViewController) withObject:nil afterDelay:5.0f];
}

- (void)newUserStart
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadingUserDataOK:) name:@"loadingUserDataOK" object:nil];
    [self switchRootViewController];
}

- (void)switchRootViewController
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    IMNavigationController *rootViewController = [[IMNavigationController alloc] initWithNibName:nil bundle:nil];
    
    [UIView transitionFromView:self.window.rootViewController.view
                        toView:rootViewController.view
                      duration:0.5f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    completion:^(BOOL finished){
                        self.window.rootViewController = rootViewController;
                        [self.window makeKeyAndVisible];
                        
                        ShopViewController *shopVC = [[ShopViewController alloc] initWithNibName:nil bundle:nil];
                        [rootViewController setRootViewController:shopVC];
                    }];
}

@end
