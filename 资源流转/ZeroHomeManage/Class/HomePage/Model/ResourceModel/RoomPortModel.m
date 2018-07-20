//
//  RoomPortModel.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/28.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "RoomPortModel.h"

@implementation RoomPortModel
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",@"nowA":@"newA"
             };
}
@end
