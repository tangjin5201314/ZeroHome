//
//  signinModel.h
//  ZeroHome
//
//  Created by TW on 16/4/14.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface signinModel : NSObject
@property (nonatomic,strong)NSString *ID;
@property (nonatomic,strong)NSString *userId;
@property (nonatomic,strong)NSString *totalSigninlFlag; //总共签到次数
@property (nonatomic,strong)NSString *monthSigninFlag; //月签到次数
@property (nonatomic,strong)NSString *signined;    //是否签到
@property (nonatomic,strong)NSString *point;     //签到积分


-(instancetype)initWith:(NSDictionary *)dict;
@end
