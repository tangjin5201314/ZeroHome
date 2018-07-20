//
//  HHTBleLockerService.h
//  HHTBleLocker
//
//  Created by xiaoxiong on 16/4/5.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GoplusCallback.h"


@interface GoplusManager : NSObject

/**
 *  获取果加蓝牙管理类单例对象
 *
 *  @return 果加蓝牙管理类单例对象
 */
+ (GoplusManager *) sharedManager;

/**
 *  初始化配置
 */
- (void)initConfig;

/**
 *  检测当前蓝牙状态是否正常
 *
 *  @param callBackHandle 检测回调
 */
//- (void)checkBleAvailable:(void(^)(GoplusCallback *callBack))callBackHandle;

/**
 *  根据门锁的编号、操作单号执行开门操作
 *
 *  @param authCode         授权码
 *  @param callbackHandle   开锁的回调
 */

- (void)openLock:(NSString *)authCode callBackHandle:(void(^)(NSString *callBackCode))callbackHandle;

/**
 *  根据门锁编号执行重置门锁时间（校时操作）
 *
 *  @param authCode         授权码
 *  @param callbackHandle   设置时间的回调
 */
- (void)resetTime:(NSString *)authCode callBackHandle:(void (^)(NSString *callBackCode))callbackHandle;
@end
