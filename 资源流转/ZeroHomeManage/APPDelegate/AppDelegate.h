//
//  AppDelegate.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/7.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong)NSString *Address;
@property (nonatomic,strong)NSCache *portCache;
/**
 *  推送channelId
 */
@property(nonatomic,strong)NSString *channelId;

@property(nonatomic,strong)NSString *CoreVersion;
@property(nonatomic,strong)NSString *Versions;
@property(nonatomic,strong)NSString *releaseRank;


@property(nonatomic,strong)NSDictionary *launchOptions;
@property(nonatomic,strong)NSData *deviceToken;

@end

