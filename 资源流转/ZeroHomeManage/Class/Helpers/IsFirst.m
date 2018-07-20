//
//  IsFirst.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/7.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "IsFirst.h"

@implementation IsFirst
+(BOOL)IsFirst{
    NSString *first = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsFirst"];
    if(first==nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"IsFirst"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}


+(BOOL)IsFirstEnterChecke{
    NSString *first = [[NSUserDefaults standardUserDefaults] objectForKey:@"IsFirstEnter"];
    if(first==nil){
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"IsFirstEnter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }else{
        return NO;
    }
}
@end
