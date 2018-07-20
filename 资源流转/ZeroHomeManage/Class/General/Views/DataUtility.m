//
//  JPDataUtility.m
//  TaskRabbit
//
//  Created by ShiXiong on 14-6-30.
//  Copyright (c) 2014年 junepartner. All rights reserved.
//

#import "DataUtility.h"

#define ALPHA           @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define NUMBERS         @"0123456789"
#define ALPHANUM        @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#define CARDID          @"0123456789Xx"
#define ALLCHAR         @""

@implementation DataUtility

/**
 验证手机号是否合法
 @params phoneNumber 手机号
 @returns 手机号有效返回YES
 **/
+ (BOOL)isPhoneNumberValid:(NSString *)phoneNumber
{
    // 130-139  150-153,155-159  180-189  145,147  170,171,173,176,177,178
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[56789])|(166)|(17[013456789])|(19[89]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}

+ (int)JudgePhoneNumber:(NSString *)phoneNum
{
//    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    if ([regextestcm evaluateWithObject:phoneNum] == YES){
        //移动
        return 0;
    }else if ([regextestct evaluateWithObject:phoneNum] == YES){
        //电信
        return 1;
    }else  if ([regextestcu evaluateWithObject:phoneNum] == YES){
        //联通
        return 2;
    }else{
        return 3;
    }
}

/**
 验证字符是否符合规则
 @params text 手机号
 @params
 @returns 手机号有效返回YES
 **/
+ (BOOL)verifyText:(NSString *)text satisfyRule:(JPTextRuleType)ruleType
{
    NSString *ruleString = @"";
    switch (ruleType) {
        case 1:
            ruleString = ALPHA;
            break;
        case 2:
            ruleString = NUMBERS;
            break;
        case 3:
            ruleString = CARDID;
            break;
        default:
            ruleString = ALPHANUM;
            break;
    }
    
    NSCharacterSet *cs;
    cs = [[NSCharacterSet characterSetWithCharactersInString:ruleString] invertedSet];
    NSArray *stringList = [text componentsSeparatedByCharactersInSet:cs];
    NSString *filtered = [stringList componentsJoinedByString:@""];
    BOOL basicTest = [text isEqualToString:filtered];
    return basicTest;
}

/**
 获取中英文混合字符串长度
 @params strtemp 中英文混合字符串
 @returns 中英文混合字符串长度
 **/
+ (NSInteger)convertToCountWithString:(NSString*)string
{
    float length = 0;
    NSString * tempString = string;
    for (int i = 0; i < [tempString length]; i++) {
        NSString * stt = [tempString substringWithRange:NSMakeRange(i, 1)];
        if ([stt lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            length ++;
        } else {
            length += 1;
        }
    }
    return length;
}

/**
 清除数组中的NSNull对象
 @params array 包含有null对象的数组
 @returns 不包含null对象的数组
 **/
+ (NSArray *)returnArray:(NSArray *)array {
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger index,BOOL *stop){
        if (obj == [NSNull null]) {
            [mutableArray addObject:@""];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [mutableArray addObject:[DataUtility
                                     returnArray:array]];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [mutableArray addObject:[DataUtility returnDictionary:obj]];
        } else {
            [mutableArray addObject:obj];
        }
    }];
    return mutableArray;
}

/**
 清除字典中的NSNull对象
 @params dictionary 包含有null对象的字典
 @returns 不包含null对象的字典
 **/
+ (NSDictionary *)returnDictionary:(NSDictionary *)dictionary {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop){
        if (obj == [NSNull null]) {
            [mutableDictionary setObject:@"" forKey:key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            [mutableDictionary setObject:[DataUtility returnArray:obj]
                                  forKey:key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [mutableDictionary setObject:[DataUtility returnDictionary:obj]
                                  forKey:key];
        } else {
            [mutableDictionary setObject:obj forKey:key];
        }
    }];
    return mutableDictionary;
}

/**
 判断对象是不是空对象
 @params object 判断对象
 @returns bool值
 **/
+ (BOOL)isBlankObject:(id)object {
    if (object == nil) {
        return YES;
    }
    if (object == NULL) {
        return YES;
    }
    if ([object isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([object isEqual:[NSNull null]]) {
        return YES;
    }
    if ([object isKindOfClass:[NSString class]]) {
        if ([[object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
            return YES;
        } else {
            const char *str = [object UTF8String];
            if (strlen(str) == 0) {
                return YES;
            }
        }
    }
    return NO;
}


/**
 判断对象是不是有效的邮箱
 @params object 判断对象
 @returns bool值
 **/
+ (BOOL)isValidateEmail:(NSString *)email{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 判断对象是不是有效的身份证号码
 @params object 判断对象
 @returns bool值
 **/
+ (BOOL)judgeIdentityStringValid:(NSString *)identityString {
    
    if (identityString.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}

+ (NSString *)iphoneType
{
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    

    return platform;
    
}

@end
