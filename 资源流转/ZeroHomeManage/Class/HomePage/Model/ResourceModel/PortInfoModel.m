//
//  PortInfoModel.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/28.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "PortInfoModel.h"

@implementation PortInfoModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"roomPortVOs": @"RoomPortModel"};
}

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}
@end
