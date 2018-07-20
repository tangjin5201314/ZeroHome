//
//  userCenterModel.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface userCenterModel : NSObject
@property (nonatomic,strong)NSString *headPortrait; //头像
@property (nonatomic,strong)NSString *nickname; // 昵称
@property (nonatomic,strong)NSString *pointLevel; //等级
@property (nonatomic,strong)NSString *sex; //性别
@property (nonatomic,strong)NSString *validPoint;    //积分
@property (nonatomic,strong)NSString *userId;    //用户id

-(instancetype)initWith:(NSDictionary *)dict;
@end
