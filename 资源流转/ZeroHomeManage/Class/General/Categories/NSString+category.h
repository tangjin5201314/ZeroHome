//
//  NSString+category.h
//  iLearning
//
//  Created by Sidney on 13-8-20.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@interface NSString (category)

/*字符串转 MD5*/
- (NSString *)stringFromMD5;
/*字符串转 sha1*/
- (NSString *)sha1;
/*字符加换行符号\n*/
- (NSString *)appNextLineKeyword:(NSString *)word;

/* NSArray or NSDitionary to JsonString */
+ (NSString *)objectTojsonString:(id)object;
+ (id)jsonStringToObject:(NSString *)jsonString;


/*获取字符串的长度*/
- (CGSize)getSizeOfStringFontSize:(int)fontSize constroSize:(CGSize)size;
- (CGSize)getSizeOfString:(UIFont *)font constroSize:(CGSize)size;

/*邮箱验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateEmail;
/*手机号码验证 MODIFIED BY HELENSONG*/
- (BOOL)isValidateMobile;
/*车牌号验证 MODIFIED BY HELENSONG*/
- (BOOL)validateCarNo;

//获取当前的时间字符串
+ (NSString *)getCurrentDateString;

+ (NSString *)getTimerIntervalSince1970;

+ (NSString *)getCurrentYear:(NSDate*)date;

+ (NSString *)getCurrentMonth:(NSDate*)date;

+ (NSString *)getCurrentDay:(NSDate*)date;

+ (NSString *)getCurrentWeek:(NSDate*)date;

+ (NSString *)getCurrentDays:(NSDate*)date;

+ (NSString *)getCurrentHaziWeek:(NSInteger)week;


//NSDate 转 NSString
+ (NSString *)dateToString:(NSDate *)date;
//yyyy-MM-dd HH:mm
+ (NSString *)dateToStringYYYMMDDHHMM:(NSDate *)date;

+ (NSString *)dateToStringWithString:(NSString *)dateStr;

//汉字编码
-(NSString *)URLEncodedStringbj;
//几小时前或几天前
- (NSString *)timeInfoWithDateString;

// 截取字符串方法封装
- (NSString *)subStringFrom:(NSString *)startString to:(NSString *)endString;

@end
