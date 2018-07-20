//
//  NSString+category.m
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSString+category.h"
#import <CommonCrypto/CommonDigest.h>
#import "DataUtility.h"

@implementation NSString (category)

- (NSString *)appNextLineKeyword:(NSString *)word
{
    NSMutableString *temp = [[NSMutableString alloc] init];
    for (int i=0; i<[word length]; i++) {
        [temp appendFormat:[word substringWithRange:NSMakeRange(i, 1)]];
        [temp appendFormat:@"\n"];
    }
    return temp;
}

#pragma mark Encryption
- (NSString *)stringFromMD5
{
    if(self == nil || [self length] == 0)
        return nil;
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, strlen(value), outputBuffer);
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

#pragma mark Encryption
- (NSString*)sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:[self length]];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

+ (id)jsonStringToObject:(NSString *)jsonString
{
    NSData * objData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    id obj = [NSJSONSerialization JSONObjectWithData:objData options:NSJSONReadingMutableContainers error:nil];
    return obj;
}



+ (NSString*)objectTojsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

- (CGSize)getSizeOfString:(UIFont *)font constroSize:(CGSize)size
{
    //    CGSize s = [self sizeWithFont:font constrainedToSize:size];
    
    NSDictionary *attribute = @{NSFontAttributeName:font};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
    
    return rect.size;
}

- (CGSize)getSizeOfStringFontSize:(int)fontSize constroSize:(CGSize)size
{
    //    CGSize s = [self sizeWithFont:[UIFont systemFontOfSize:fontSize]
    //               constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGRect rect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    return rect.size;
}

- (BOOL)isValidateEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (BOOL)isValidateMobile
{
    //手机号以13，14, 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    //    BOOL b = [phoneTest evaluateWithObject:mobile];
    return [phoneTest evaluateWithObject:self];
}

- (BOOL)validateCarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}


+ (NSString *)getCurrentDateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dateFormatter setDateFormat:@"HH(24制):hh(12制):mm 'on' EEEE MMMM d"];
    NSString * date = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"date%@",date);
    return date;
}

+ (NSString *)getTimerIntervalSince1970
{
    
    NSString * timeIntervalSince1970 = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    return timeIntervalSince1970;
}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSString *)dateToStringYYYMMDDHHMM:(NSDate *)date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterFullStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}


+ (NSString *)dateToStringWithString:(NSString *)dateStr
{
    if ([DataUtility isBlankObject:dateStr]||[dateStr isEqualToString:@"0"]) {
        return @"";
    }else{
      
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[dateStr doubleValue]/1000];
        NSString *startDateStr = [dateFormatter stringFromDate: startdate];
        return startDateStr;
    }
    
}

+ (NSString *)getCurrentYear:(NSDate*)date{
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags= NSCalendarUnitYear;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    return [NSString stringWithFormat:@"%ld",(long)year];
}
+ (NSString *)getCurrentMonth:(NSDate*)date{
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags= NSCalendarUnitMonth;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger month=[conponent month];
    return [NSString stringWithFormat:@"%ld",(long)month];
}
+ (NSString *)getCurrentDay:(NSDate*)date{
    
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags= NSCalendarUnitDay;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger day=[conponent day];
    return [NSString stringWithFormat:@"%ld",(long)day];
    
}

+ (NSString *)getCurrentWeek:(NSDate*)date{
    
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags= NSCalendarUnitWeekday;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger week=[conponent weekday];
    return [NSString stringWithFormat:@"%ld",(long)week];
    
}

+ (NSString *)getCurrentHaziWeek:(NSInteger)week{
    switch (week) {
        case 1:
            return @"一";
            break;
        case 2:
            return @"二";
            break;
        case 3:
            return @"三";
            break;
        case 4:
            return @"四";
            break;
        case 5:
            return @"五";
            break;
        case 6:
            return @"六";
            break;
        case 0:
            return @"日";
            break;
        default:
            break;
    }
    return @"";
}

+ (NSString *)getCurrentDays:(NSDate*)date{
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSRange days = [c rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:date];
    //    NSLog(@"%@",NSStringFromRange(days));
    NSString* ds = [NSString stringWithFormat:@"%lu",(unsigned long)days.length];
    return ds;
}

// 截取字符串方法封装
// 截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString{
    
    NSRange startRange = [self rangeOfString:startString];
    NSRange endRange = [self rangeOfString:endString];
    NSRange range = NSMakeRange(startRange.location + startRange.length, endRange.location - startRange.location - startRange.length);
    return [self substringWithRange:range];
    
}

/**
 URL Encode
 EscapedInQueryString 使用的AFN里面的 目前接口没有对 + 进行编码.所以会引起签名错误.其他特殊符号暂时不清楚是否进行编码
 */
- (NSString *)URLEncodedStringbj
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@":/?&=;+!@#$()',*", kCFStringEncodingUTF8));
    //
    //    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, NULL, (CFStringRef)@"!*’();:@&=+$,/?%#[] ", kCFStringEncodingUTF8));
    
    //    NSString *encodedString = (NSString *)
    //    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
    //                                            (CFStringRef)self,
    //                                            (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
    //                                            NULL,
    //                                            kCFStringEncodingUTF8));
    //    return encodedString;
}
- (NSString *)timeInfoWithDateString{
    // 把日期字符串格式化为日期对象
    NSDate *date = [NSDate date];
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%f", ti];
    NSLog(@"%@,%@",timeString,self);
    
    NSInteger Different = [timeString integerValue]-[self integerValue];
    if(Different<60){
        return [NSString stringWithFormat:@"%ld秒前",Different];
    }else if(Different<3600){
        return [NSString stringWithFormat:@"%ld分钟前",(NSInteger)(Different/60)];
    }else if(Different<86400){
        return [NSString stringWithFormat:@"%ld小时前",(NSInteger)(Different/3600)];
    }else{
        NSLog(@"%@",[NSString stringWithFormat:@"%ld天前",(NSInteger)(Different/86400)]);
        return [NSString stringWithFormat:@"%ld天前",(NSInteger)(Different/86400)];
    }
    
}
//    NSDate *date = [NSDate dateFromString:dateString withFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    NSDate *curDate = [NSDate date];
//    NSTimeInterval time = -[date timeIntervalSinceDate:curDate];
//    
//    int month = (int)([curDate getMonth] - [date getMonth]);
//    int year = (int)([curDate getYear] - [date getYear]);
//    int day = (int)([curDate getDay] - [date getDay]);
//    
//    NSTimeInterval retTime = 1.0;
//    // 小于一小时
//    if (time < 3600) {
//        retTime = time / 60;
//        retTime = retTime <= 0.0 ? 1.0 : retTime;
//        return [NSString stringWithFormat:@"%.0f分钟前", retTime];
//    }
//    // 小于一天，也就是今天
//    else if (time < 33600 * 24) {
//        retTime = time / 3600;
//        retTime = retTime <= 0.0 ? 1.0 : retTime;
//        return [NSString stringWithFormat:@"%.0f小时前", retTime];
//    }
//    // 昨天
//    else if (time < 33600 * 224 * 2) {
//        return @"昨天";
//    }
//    // 第一个条件是同年，且相隔时间在一个月内
//    // 第二个条件是隔年，对于隔年，只能是去年12月与今年1月这种情况
//    else if ((abs(year) == 0 && abs(month) <= 1)
//             || (abs(year) == 1 && [curDate getMonth] == 1 && [date getMonth] == 12)) {
//        int retDay = 0;
//        // 同年
//        if (year == 0) {
//            // 同月
//            if (month == 0) {
//                retDay = day;
//            }
//        }
//        
//        if (retDay <= 0) {
//            // 这里按月最大值来计算
//            // 获取发布日期中，该月总共有多少天
//            int totalDays = [NSDate daysInMonth:(int)[date getMonth] year:(int)[date getYear]];
//            // 当前天数 + （发布日期月中的总天数-发布日期月中发布日，即等于距离今天的天数）
//            retDay = (int)[curDate getDay] + (totalDays - (int)[date getDay]);
//            
//            if (retDay >= totalDays) {
//                return [NSString stringWithFormat:@"%d个月前", (abs)(MAX(retDay / 31, 1))];
//            }
//        }
//        
//        return [NSString stringWithFormat:@"%d天前", (abs)(retDay)];
//    } else  {
//        if (abs(year) <= 1) {
//            if (year == 0) { // 同年
//                return [NSString stringWithFormat:@"%d个月前", abs(month)];
//            }
//            
//            // 相差一年
//            int month = (int)[curDate getMonth];
//            int preMonth = (int)[date getMonth];
//            
//            // 隔年，但同月，就作为满一年来计算
//            if (month == 12 && preMonth == 12) {
//                return @"1年前";
//            }  
//            
//            // 也不看，但非同月  
//            return [NSString stringWithFormat:@"%d个月前", (abs)(12 - preMonth + month)];  
//        }  
//        
//        return [NSString stringWithFormat:@"%d年前", abs(year)];  
//    }  
//    
//    return @"1小时前";  

@end
