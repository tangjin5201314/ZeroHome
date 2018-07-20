//
//  UserListModel.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/21.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "UserListModel.h"

@implementation UserListModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end
