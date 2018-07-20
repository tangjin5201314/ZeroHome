//
//  AppDelegate.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/7.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "AppDelegate.h"
#import "IsFirst.h"
//微信SDK头文件
#import "WXApi.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "FirstViewController.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "HttpRequest.h"
#import "UIUtility.h"
#import "BPush.h"
#import "UserDefalut.h"
#import "HomePageViewController.h"
#import "TabBarMainViewController.h"
#import "ResourceHomeController.h"
#import "WorkOrderHomeController.h"
#import "AdminViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "WuyeViewController.h"
#import "AuthentifiModel.h"
#import "MJExtension.h"
#import "DataUtility.h"
#import <UserNotifications/UserNotifications.h>
#import "IQKeyboardManager.h"
@interface AppDelegate ()<UIAlertViewDelegate,CBCentralManagerDelegate>

@property (nonatomic,strong) CBCentralManager *bluetoothManager;
@property (nonatomic,strong)TabBarMainViewController *tabVC;

@end

@implementation AppDelegate{
    UserDefalut *user;
    NSString *strVerUrl;
    NSDictionary *userInfoDic;
}
//#define UMAPPKEY @"55ed28a867e58e7c980028e5"


#define QQAPPKEY @"CC78gNYiJvBCf0uo"
#define QQAPPID @"1104848150"
#define wechatAppId @"wx80ee58f26866370d"
#define wechatAppSecret @"adede4b66cb2aee40eedef21dcd16496"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    //初始化蓝牙设置
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

    
    //友盟统计
    [MobClick startWithAppkey:UMAPPKEY reportPolicy:BATCH channelId:@"Web"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    //设置友盟key
    [UMSocialData setAppKey:UMAPPKEY];

    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskLandscape];
    //设置qq
    [UMSocialQQHandler setQQWithAppId:QQAPPID appKey:QQAPPKEY url:@"http://www.umeng.com/social"];
    //设置微信
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:wechatAppId appSecret:wechatAppSecret url:ShareToWeixinURL];
    
    [WXApi registerApp:wechatAppId];
    //设置百度推送
    // iOS8 下需要使用新的 API
    [self registerRemoteNotification];
    
//#warning 测试 开发环境 时需要修改BPushMode为BPushModeDevelopment 需要修改Apikey为自己的Apikey
    
    // 在 App 启动时注册百度云推送服务，需要提供 Apikey
    [BPush registerChannel:launchOptions apiKey:TomBaiDuPuShAPIKEY pushMode:BPushModeProduction withFirstAction:nil withSecondAction:nil withCategory:nil isDebug:NO];
    // App 是用户点击推送消息启动
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSLog(@"从消息启动:%@",userInfo);
        [BPush handleNotification:userInfo];
    }
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
   
    NSLog(@"百度推送===》%d",[[[NSUserDefaults standardUserDefaults] objectForKey:@"allowPush"] boolValue]);
    [self IsFirst];
//    [self getBuilder];
    
    self.portCache = [[NSCache alloc]init];
    
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.enable = YES;
    keyboardManager.shouldResignOnTouchOutside = YES;
    keyboardManager.enableAutoToolbar = YES;
    keyboardManager.shouldShowToolbarPlaceholder = YES;

    [self.window makeKeyAndVisible];
    return YES;
}

/** 注册 APNs */
- (void)registerRemoteNotification {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0 // Xcode 8编译会调用
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error) {
                NSLog(@"request authorization succeeded!");
            }
        }];
        
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#else // Xcode 7编译会调用
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
#endif
    } else {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

// 此方法是 用户点击了通知，应用在前台 或者开启后台并且应用在后台 时调起
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [BPush handleNotification:userInfo];
    NSLog(@"userInfo==%@",userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSLog(@"********** iOS7.0之后 background **********");
    
    // 应用在前台 或者后台开启状态下，不跳转页面，让用户选择。
    userInfoDic = userInfo;
    if (application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateBackground) {
        NSLog(@"acitve or background");
        NSString *message;
        if ([userInfo[@"tag"] integerValue] == 1) { //授权申请的推送
            message = @"门锁申请审批完成，请刷新界面";
        }else if ([userInfo[@"tag"] integerValue] == 2){ //提交申请的推送
            message = @"有门锁申请提交，请刷新界面";
        }
        UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"收到一条消息" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        alertView.tag = 12;
        [alertView show];
    }
    else//杀死状态下，直接跳转到跳转页面。
    {
        
        [self goToMssageViewControllerWith:userInfo];
        
    }
    
}
// tuisong 在 iOS8 系统中，还需要添加这个方法。通过新的 API 注册推送服务
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    
    [application registerForRemoteNotifications];
    
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"test:%@",deviceToken);
    _deviceToken = deviceToken;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"allowPush"] boolValue]){
        [BPush registerDeviceToken:deviceToken];
        [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
            // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
            NSLog(@"result == %@",result);
            if (result) {
                _channelId = [result objectForKey:@"channel_id"];
                NSLog(@"channelId===%@",_channelId);
                [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                    NSLog(@"设置tag == %@",result);
                    if (result) {
                        NSLog(@"设置tag成功");
                    }
                }];
            }
        }];
    }
    
}
// 当 DeviceToken 获取失败时，系统会回调此方法
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"DeviceToken 获取失败，原因：%@",error);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // App 收到推送的通知
    [BPush handleNotification:userInfo];
    //角标
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    NSLog(@"消息:%@",userInfo);
}

- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic
{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    
    NSInteger target = [msgDic[@"tag"] integerValue]; //判断是哪种类型的通知
    if (target == 1) {//授权申请的推送
        [pushJudge setObject:@"push"forKey:@"push"];
        [pushJudge synchronize];
        if ([msgDic[@"type"] integerValue]== 1) {
            //通网用户
            HomePageViewController *vc = [[HomePageViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            self.window.rootViewController = nav;
            
        }else if ([msgDic[@"type"] integerValue]== 6){
            //管理员
            HomePageViewController *vc = [[HomePageViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            self.window.rootViewController = nav;
        }else{
            //运营商或者物业
            HomePageViewController *vc = [[HomePageViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            self.window.rootViewController = nav;
            
        }
        
    }else if (target == 2){//提交申请的推送
        //管理员
        [pushJudge setObject:@"submitPush"forKey:@"submitPush"];
        [pushJudge synchronize];
        AdminViewController *vc = [[AdminViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = nav;
        
    }
}

//分享回调
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url]|| [WXApi handleOpenURL:url delegate:self];
    //     return  [UMSocialSnsService handleOpenURL:url];
}


-(void)IsFirst{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    usertoken = [ud objectForKey:@"token"];
    BOOL isFirst = [IsFirst IsFirst];
    NSLog(@"%d",isFirst);
    if(isFirst){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"allowPush"];
        FirstViewController *first = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
        self.window.rootViewController = first;
    }else{
        if (!usertoken) {
            
            HttpRequest *http = [[HttpRequest alloc]init];
            
            [http stop];
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            self.window.rootViewController = nav;
            
        }else
        {
            WorkOrderHomeController *vc = [[WorkOrderHomeController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            self.window.rootViewController = nav;
      
            
        }
        
    }
}

#pragma mark -- CBCentralManagerDelegate ----
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBManagerStatePoweredOff:
        {
            NSLog(@"设备未开启");
            
            toothBlueState = @"PoweredOff";
        }
            break;
        case CBManagerStateUnsupported:
            [SVProgressHUD showInfoWithStatus:@"蓝牙设备不支持"];
            break;
        case CBManagerStateUnauthorized:
            [SVProgressHUD showInfoWithStatus:@"设备未授权"];
            break;
        case CBManagerStateResetting:
            [SVProgressHUD showInfoWithStatus:@"设备正在重置状态"];
            break;
        case CBManagerStateUnknown:
            [SVProgressHUD showInfoWithStatus:@"设备初始化时时未知的"];
            break;
        case CBManagerStatePoweredOn:
            toothBlueState = @"PoweredOn";
            break;
        default:
            break;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"程序暂停");
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"进入后台");
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];//记得立即同步
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSLog(@"进入前台");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"从后台回来");
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application;
{
    // 内存警告，清理内存
    //      [[SDImageCache sharedImageCache]clearMemory];
    [[SDWebImageManager sharedManager].imageCache clearMemory];
    [[SDWebImageManager sharedManager] cancelAll];
}

-(void)getBuilder{
    NSString *vesion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSLog(@"版本：%@",vesion);
    //获得最新版本
    HttpRequest *http = [[HttpRequest alloc]init];
    NSString *latestVersion = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kGetbanben];
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"ios",@"belong",
                                vesion,@"coreVersion",
                                usertoken,@"token",
                                nil];
    
    NSLog(@"xxxxx%@",parameters);
    [http Post1NewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获得版本信息:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            NSDictionary *message = [jsonObj objectForKey:@"message"];
            if(!IsAppStore){
                //                _Address = [message objectForKey:@"newAddress"];
                _Address = @"itms-services://?action=download-manifest&url=https%3A%2F%2Fwww.pgyer.com%2Fapiv1%2Fapp%2Fplist%3FaId%3D072e72649f493fd35d14deb34e688ff2%26_api_key%3D238775ce9976af18e80213b224927959";
            }else{
                _Address = @"https://itunes.apple.com/cn/app/资源管理/id1374725674?mt=8";
            }
            _CoreVersion = [message objectForKey:@"newCoreVersion"];
            _Versions = [message objectForKey:@"newVersions"];
            _releaseRank = [message objectForKey:@"releaseRank"];
            // _releaseRank = @"4";
            if([_releaseRank intValue]==3){
                [UIUtility showWith:@"版本更新" message:@"发现一个新版本，立即去更新吧!" delegate:self canceltitle:@"忽略" otherButtonTitles:@"现在升级" tag:11];
            }else if ([_releaseRank intValue]==4){
                [UIUtility showWith:@"版本更新" message:@"发现一个新版本，立即去更新吧!" delegate:self canceltitle:nil otherButtonTitles:@"现在升级" tag:10];
            }
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
        ;
    } byUrl:latestVersion parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"升级");
    if(alertView.tag==10){
        NSLog(@"地址：===%@",self.Address);
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_Address]];
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_Address] options:@{@"":@""} completionHandler:nil];
    }else if (alertView.tag==11){
        if(buttonIndex==1){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_Address]];
        }
    }else if (alertView.tag == 12){
        if(buttonIndex==1){
            //            [self goToMssageViewControllerWith:userInfoDic];
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSLog(@"推出");
    
}

@end
