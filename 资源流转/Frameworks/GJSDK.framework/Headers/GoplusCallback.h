//
//  GoplusCallback.h
//  GoPlusBleLocker
//
//  Created by xiaoxiong on 16/4/5.
//  Copyright © 2016年 xiaoxiong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


UIKIT_EXTERN NSString * const GoplusCallbackErrorDomain;


typedef NS_ENUM(NSInteger,GoplusCallbackErrorCode) {
    GoplusCallbackErrorCodeHH0000 = 10001,        //成功
    GoplusCallbackErrorCodeHH9999,        //其他错误
    
    GoplusCallbackErrorCodeNET00001,      //网络未连接
    GoplusCallbackErrorCodeNET00002,      //网络连接异常
    
    GoplusCallbackErrorCodeOPS00001,      //数据格式无法解析
    GoplusCallbackErrorCodeOPS02102,      //门锁信息不存在
    GoplusCallbackErrorCodeOPS07102,      //授权信息不存在
    
    GoplusCallbackErrorCodeBLE00001,      //无法找到指定门锁
    GoplusCallbackErrorCodeBLE00002,      //无法连接到指定门锁
    GoplusCallbackErrorCodeBLE00003,      //连接失败，设置通知失败
    GoplusCallbackErrorCodeBLE00004,      //发送指令数据失败
    GoplusCallbackErrorCodeBLE00005,      //发送指令数据成功，门锁无响应
    GoplusCallbackErrorCodeBLE00006,      //设备蓝牙未开启
    GoplusCallbackErrorCodeBLE00007,      //开锁指令时效有误
    GoplusCallbackErrorCodeBLE00008,      //设备不支持蓝牙
};

typedef NS_ENUM(NSInteger,GoPlusCallBackActionType) {
    GoPlusCallBackActionTypeUnlock,             //开锁操作
    GoPlusCallBackActionTypeResetTime           //校准时间操作
};




@interface GoplusCallback : NSObject

/**
 *  回调操作类型
 */
@property(nonatomic,assign)GoPlusCallBackActionType     actionType;

/**
 *  回调error
 */
@property(nonatomic,strong)NSError                      *error;

/**
 *  回调消息
 */
@property(nonatomic,strong)NSString                     *callBackMessage;



@end
