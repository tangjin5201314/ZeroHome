//
//  JPDateUtility.h
//  TaskRabbit
//
//  Created by ShiXiong on 14-6-30.
//  Copyright (c) 2014年 junepartner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

//将时间戳转化成字符串
+ (NSString *)dateStringByTimeInterval:(NSTimeInterval)timeInterval
                        withDateFormat:(NSString *)dateFormat;

//将时间字符串转化成时间戳
+ (NSTimeInterval)timeIntervalByDateString:(NSString *)dateString
                            withDateFormat:(NSString *)dateFormat;

//类似微博时间
+ (NSString*)timeStampTimeValueForKey:(NSString*)stringTime;

//获取多少小时内 
+ (NSString*)timeStampHourTimeValueForKey:(NSString*)stringTime;

//根据月份和日获取星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d;

+ (NSString *)compareTwoTime:(long long)time1 time2:(long long)time2;
+ (NSString *)getIntevalByNowDate:(NSDate *)nowDate;
@end
