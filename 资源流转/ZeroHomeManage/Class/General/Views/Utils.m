//
//  Utils.m
//  HuairouInsight
//
//  Created by xiangming on 14-5-5.
//  Copyright (c) 2014年 elitework. All rights reserved.
//

#import "Utils.h"

@implementation Utils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    return date;
}

//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [Utils dateFromFomate:datestring formate:formate];
    NSString *text = [Utils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}


+ (NSString *)getBundlePath:(NSString *)fileName
{
    NSString  *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
    return path;
}

+ (id)parseData:(NSString *)fileName
{
    NSString  *path = [Utils getBundlePath:fileName];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    return result;
}


+ (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}


+ (CGFloat)getHeightOfString:(NSString *)string withFont:(UIFont *)font  withWidth:(CGFloat)width
{
    CGSize titleSize = [string sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    return titleSize.height;
}

+ (NSString *)getContentIdWithClassType:(int)type andSelectIndex:(int)index
{
    switch (type) {
        case 0:
        {
            switch (index) {
                case 0:
                    return @"80101";
                    break;
                case 1:
                    return @"80102";
                    break;
                case 2:
                    return @"80103";
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            switch (index) {
                case 0:
                    return @"80201";
                    break;
                case 1:
                    return @"80202";
                    break;
                case 2:
                    return @"80203";
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (index) {
                case 0:
                    return @"80301";
                    break;
                case 1:
                    return @"80302";
                    break;
                case 2:
                    return @"80303";
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            return @"";
            break;
    }
    return @"";
}


//
+ (BOOL)checkPhone:(NSString *)phoneNumber {
    
    /*中国移动：134（不含1349）、135、136、137、138、139、147、150、151、152、157、158、159、182、183、184、187、188
     中国联通：130、131、132、145（上网卡）、155、156、185、186
     中国电信：133、1349（卫星通信）、153、180、181、189
     4G号段：170：[1700(电信)、1705(移动)、1709(联通)]、176(联通)、177(电信)、178(移动)
     未知号段：140、141、142、143、144、146、148、149、154
     */
    //手机号以13,15,17,18开头, 八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(14[0,0-9])|(17[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:phoneNumber];
    
}

+ (void)showAlertViewWithTitle:(NSString *)title
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒"
                                                    message:title
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}

//检测多少位到多少位的英文数字组成的字符串
+ (BOOL)isLetterAndNumberWithString:(NSString *)string
                               from:(int)from
                                 to:(int)to
{
    NSString * regex = [NSString stringWithFormat:@"^[A-Za-z0-9]{%d,%d}$",from,to];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

//检测多少位到多少位的字符串
+ (BOOL)isCharacterWithWithString:(NSString *)string
                             from:(int)from
                               to:(int)to
{
    NSString *regex = [NSString stringWithFormat:@"[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]{%d,%d}$",from,to];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}


@end
