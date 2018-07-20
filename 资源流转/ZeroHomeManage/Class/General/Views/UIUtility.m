//
//  JPUIUtility.m
//  TaskRabbit
//
//  Created by xiangming on 14-7-5.
//  Copyright (c) 2014年 junepartner. All rights reserved.
//

#import "UIUtility.h"
#import <AVFoundation/AVFoundation.h>
#import "DateUtility.h"


@implementation UIUtility

+ (void)showAlertViewWithTitle:(NSString *)title messsge:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}
+(void)showWith:(NSString *)title message:(NSString *)message delegate:(id)delegate canceltitle:(NSString *)cancelTitle otherButtonTitles:(NSString *)other tag:(int)tag{
    
    
   UIAlertView *aleart = [[UIAlertView alloc]initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelTitle otherButtonTitles:other, nil];
    aleart.tag = tag;
    [aleart show];
}



//计算文字宽度（UILabel）
+ (CGFloat)getLabelWidthOfText:(NSString *)text
                       andFont:(UIFont *)font
{
    CGSize titleSize = [text sizeWithFont:font];
    return titleSize.width;
}

//计算文字高度（UILabel）
+ (CGFloat)getHeightOfString:(NSString *)string
                    withFont:(UIFont *)font
                   withWidth:(CGFloat)width
{
    CGSize titleSize = [string sizeWithFont:font
                          constrainedToSize:CGSizeMake(width, MAXFLOAT)
                              lineBreakMode:NSLineBreakByCharWrapping];
    return titleSize.height;
}

+ (void)playVibrate
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}


//是否需要更新更新用户位置
+ (BOOL)needToUpdateUserlocation
{
    NSDate *currentDate  = [NSDate date];
    NSString *lastClearDateStr = [UIUtility valueForKey:kLastClearCacheDate];
    if(lastClearDateStr){
        NSDate  *lastClearDate = [UIUtility dateFromFomate:lastClearDateStr formate:@"yy-MM-dd HH:mm"];
        NSTimeInterval interVal = [currentDate timeIntervalSinceDate:lastClearDate];
        if(interVal>=kNeedToUpdateCacheTimeInterVal){//清除缓存
            NSString *currendateString = [UIUtility stringFromFomate:currentDate formate:@"yy-MM-dd HH:mm"];
            [UIUtility setValue:currendateString forKey:kLastClearCacheDate];
            return YES;
        }
        return NO;
    }
    else{
        //更新上次自动清理缓存的时间
        NSString *currendateString = [UIUtility stringFromFomate:currentDate formate:@"yy-MM-dd HH:mm"];
        [UIUtility setValue:currendateString forKey:kLastClearCacheDate];
        return NO;
    }
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
    NSDate *createDate = [UIUtility dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtility stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}

+ (void)setValue:(id)value forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)valueForKey:(NSString *)key {
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

//判断textField里面是否有空
+(BOOL)textFieldIsNOTEmpt:(UITextField *)textField{
    if ([textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length!=0){
        return YES;
    }else {
        return NO;
    }
}


@end
