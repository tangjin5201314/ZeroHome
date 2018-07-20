//
//  Utils.h
//  HuairouInsight
//
//  Created by xiangming on 14-5-5.
//  Copyright (c) 2014年 elitework. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
@interface Utils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;
//将日期转化成指定格式的字符串
+ (NSString *)fomateString:(NSString *)datestring;


//解析json数据
+ (id)parseData:(NSString *)fileName;

//获取沙盒文件
+ (NSString *)getBundlePath:(NSString *)fileName;




//存取键值对
+ (void)setValue:(id)value forKey:(NSString *)key; //将键值对存储到NSUserDefault中
+ (id)valueForKey:(NSString *)key; //从NSUserDefault中得到key对应的value

//计算文字高度（UILabel）
+ (CGFloat)getHeightOfString:(NSString *)string withFont:(UIFont *)font  withWidth:(CGFloat)width;

+ (NSString *)getContentIdWithClassType:(int)type andSelectIndex:(int)index;


+ (BOOL)checkPhone:(NSString *)phoneNumber;

+ (void)showAlertViewWithTitle:(NSString *)title;

+ (BOOL)isLetterAndNumberWithString:(NSString *)string
                               from:(int)from
                                 to:(int)to;

+ (BOOL)isCharacterWithWithString:(NSString *)string
                             from:(int)from
                               to:(int)to;

@end
