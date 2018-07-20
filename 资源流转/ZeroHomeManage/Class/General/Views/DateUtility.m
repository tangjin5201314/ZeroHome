//
//  JPDateUtility.m
//  TaskRabbit
//
//  Created by ShiXiong on 14-6-30.
//  Copyright (c) 2014年 junepartner. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

/**
 将时间戳转化成字符串
 @params timeInterval   时间戳
 @params dateFormat     时间字符格式
 @returns 时间字符串
 **/
+ (NSString *)dateStringByTimeInterval:(NSTimeInterval)timeInterval
                        withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:dateFormat];
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}

/**
 将时间字符串转化成时间戳
 @params dateString   时间字符串
 @params dateFormat   时间字符格式
 @returns 时间戳
 **/
+ (NSTimeInterval)timeIntervalByDateString:(NSString *)dateString
                            withDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = dateFormat;
    NSDate *date = [dateFormatter dateFromString:dateString];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    return timeInterval;
}

+ (NSString *)time
{
    return @"aa";
}

#pragma mark - Private Method
// 获取时间戳
+ (time_t)getTimeValueForKey:(NSString*)stringTime
                defaultValue:(time_t)_defaultValue
{
    if((id)stringTime == [NSNull null]){
        stringTime = @"";
    }
    //声明时间结构体变量，用于存放有关时间的变量，引自time.h
    struct tm created;
    time_t now;
    time(&now);
    
    if(stringTime){
        //strptime()，按照特定时间格式将字符串转换为时间类型。
        if (strptime([stringTime UTF8String], "%a %b %d %H:%M:%S %z %Y", &created) == NULL){
            strptime([stringTime UTF8String], "%a, %d %b %Y %H:%M:%S %z", &created);
        }
        //创建时间信息返回
        return mktime(&created);
    }
    return _defaultValue;
}

// 获取时间字符串
+ (NSString*)timeStampTimeValueForKey:(NSString*)stringTime
{
    //定一个时间戳字符串对象
    NSString* _timeStamp = @"";
    
    //获取当前具体时间，精确到秒
    time_t now;
    time(&now);
    
    //    time_t createdAt = [JPDateUtility getTimeValueForKey:stringTime defaultValue:0];
    time_t createdAt = [stringTime floatValue];
    int distance = (int)difftime(now, createdAt);
    
    //忽略时间误差
    if(distance < 0) {
        distance = 0;
    }
    
    if(distance < 60) {
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"秒前"];
    } else if(distance < 60 * 60){
        distance = distance / 60;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"分钟前"];
    }
    else if(distance < 60 * 60 * 24){
        distance = distance / 60 / 60;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"小时前"];
    }
    else if(distance < 60 * 60 * 24 * 7){
        distance = distance / 60 / 60 / 24;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"天前"];
    }
    else if(distance < 60 * 60 * 24 * 7 * 4){
        distance = distance / 60 / 60 / 24 / 7;
        _timeStamp = [NSString stringWithFormat:@"%d%@",distance,@"周前"];
    }
    else{
        static NSDateFormatter * dateFormatter = nil;
        if(dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy.MM.dd"];
        }
        NSDate* date = [NSDate  dateWithTimeIntervalSince1970:createdAt];
        _timeStamp = [dateFormatter stringFromDate:date];
    }
    return _timeStamp;
}

// 获取时间字符串
+ (NSString*)timeStampHourTimeValueForKey:(NSString*)stringTime
{
    //定一个时间戳字符串对象
    NSString* _timeStamp = @"";
    
    //获取当前具体时间，精确到秒
    time_t now;
    time(&now);
    
    time_t createdAt = [stringTime floatValue];
    int distance = (int)difftime(createdAt, now);
    
    //忽略时间误差
    if(distance < 0) {
        distance = 0;
    }
    
    if (distance < 60 * 60 * 24) {
        if(distance<60*60){
            distance = distance/60;
            _timeStamp = [NSString stringWithFormat:@"%d分钟内", distance];
        }
        else{
            distance = distance / 60 / 60;
            _timeStamp = [NSString stringWithFormat:@"%d小时内", distance];
        }
    } else if (distance < 60 * 60 * 24 * 7) {
        distance = distance / 60 / 60 / 24;
        _timeStamp = [NSString stringWithFormat:@"%d天内", distance];
    } else if (distance < 60 * 60 * 24 * 7 * 4) {
        distance = distance / 60 / 60 / 24 / 7;
        _timeStamp = [NSString stringWithFormat:@"%d周内", distance];
    } else if (distance < 60 * 60 * 24 * 28) {
        
    } else {
        static NSDateFormatter * dateFormatter = nil;
        if(dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"M月dd日"];
        }
        NSDate* date = [NSDate  dateWithTimeIntervalSince1970:createdAt];
        _timeStamp = [dateFormatter stringFromDate:date];
    }
    return _timeStamp;
}

+(NSString *)getAstroWithMonth:(int)m day:(int)d
{
    
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    
    NSString *astroFormat = @"102123444543";
    
    NSString *result;
    
    if (m<1||m>12||d<1||d>31){
        
        return @"错误日期格式!";
        
    }
    
    if(m==2 && d>29)
        
    {
        
        return @"错误日期格式!!";
        
    }else if(m==4 || m==6 || m==9 || m==11) {
        
        if (d>30) {
            
            return @"错误日期格式!!!";
            
        }
        
    }
    
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
    
}


//计算两个时间戳的时间差

+ (NSString *)compareTwoTime:(long long)time1 time2:(long long)time2

{
    
    NSTimeInterval balance = time2 - time1 ;
    
    NSString *timeString = [[NSString alloc]init];
    
    timeString = [NSString stringWithFormat:@"%f",balance /60];
    
    timeString = [timeString substringToIndex:timeString.length-7];
    
    NSInteger timeInt = [timeString intValue];
    
    NSInteger hour = timeInt /60;
    
    NSInteger mint = timeInt %60;
    
    if(hour ==0) {
        
        timeString = [NSString stringWithFormat:@"%ld分钟",(long)mint];
        
    }
    
    else
        
    {
        
//        if(mint ==0) {
        
            timeString = [NSString stringWithFormat:@"%ld小时",(long)hour];
            
//        }
        
//        else
//
//        {
//
//            timeString = [NSString stringWithFormat:@"%ld小时%ld分钟",(long)hour,(long)mint];
//
//        }
        
    }
    
    return timeString;
    
}

+ (NSString *)getIntevalByNowDate:(NSDate *)nowDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSString *currentTimeString = [formatter stringFromDate:nowDate];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
}

@end

