//
//  NSDate+category.m
//  NovartisPPH
//
//  Created by Sidney on 13-10-16.
//  Copyright (c) 2013年 iSoftstone infomation Technology (Group) Co.,Ltd. All rights reserved.
//

#import "NSDate+category.h"

@implementation NSDate (category)

+ (NSDate *)stringToDate:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [dateFormatter dateFromString:dateString];
    return date;
}

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month

{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setMonth:month];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
    
}

+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withDay:(int)day{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    [comps setDay:day];
    
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    return mDate;
}


@end
