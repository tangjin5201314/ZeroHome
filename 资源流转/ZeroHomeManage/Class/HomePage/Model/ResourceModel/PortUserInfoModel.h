//
//  PortUserInfoModel.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/3/31.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortUserInfoModel : NSObject
@property (nonatomic,strong)NSString *clientele_name;
@property (nonatomic,strong)NSString *clientele_tel;
@property (nonatomic,strong)NSString *combo;
@property (nonatomic,strong)NSString *expireTime;
@property (nonatomic,strong)NSString *installaTime;
@property (nonatomic,strong)NSString *openTime;
@property (nonatomic,assign)NSInteger operatorType;
@property (nonatomic,assign)NSInteger portId;
@property (nonatomic,assign)NSInteger userLockId;
@property (nonatomic,strong)NSString *wordOrder;
@property (nonatomic,assign)NSInteger ID;


@end
