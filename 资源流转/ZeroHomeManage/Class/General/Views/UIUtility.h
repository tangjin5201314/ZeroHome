//
//  JPUIUtility.h
//  TaskRabbit
//
//  Created by xiangming on 14-7-5.
//  Copyright (c) 2014年 junepartner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

//每周五更新缓存
#define kNeedToUpdateCacheTimeInterVal 1*60

#define kLastClearCacheDate @"kLastClearCacheDate"

@interface UIUtility : NSObject

//alert
+ (void)showAlertViewWithTitle:(NSString *)title messsge:(NSString *)message;

+(void)showWith:(NSString *)title message:(NSString *)message delegate:(id)delegate canceltitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)other  tag:(int)tag;

//计算文字宽度（UILabel）
+ (CGFloat)getLabelWidthOfText:(NSString *)text andFont:(UIFont *)font;

//计算文字高度（UILabel）
+ (CGFloat)getHeightOfString:(NSString *)string withFont:(UIFont *)font  withWidth:(CGFloat)width;

//播放系统震动
+ (void)playVibrate;

// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;
//将日期转化成指定格式的字符串
+ (NSString *)fomateString:(NSString *)datestring;

//是否需要更新更新用户位置
+ (BOOL)needToUpdateUserlocation;


//存取键值对
+ (void)setValue:(id)value forKey:(NSString *)key; //将键值对存储到NSUserDefault中
+ (id)valueForKey:(NSString *)key; //从NSUserDefault中得到key对应的value

+(BOOL)textFieldIsNOTEmpt:(UITextField *)textField;
@end
