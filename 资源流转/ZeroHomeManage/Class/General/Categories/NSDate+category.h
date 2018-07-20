//
//  NSDate+category.h
//  NovartisPPH
//
//  Created by Sidney on 13-10-16.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (category)

//NSString to NSDate
+ (NSDate *)stringToDate:(NSString *)dateString;

//给一个时间，给一个数，正数是以后n个月，负数是前n个月；
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(int)day;



@end
