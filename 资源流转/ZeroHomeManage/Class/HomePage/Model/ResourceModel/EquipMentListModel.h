//
//  EquipMentListModel.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EquipMentListModel : NSObject
@property (nonatomic,strong)NSString *equipmentCode;
@property (nonatomic,assign)NSInteger countMY;
@property (nonatomic,assign)NSInteger count;
@property (nonatomic,assign)NSInteger userCount;
@property (nonatomic,assign)NSInteger ID;

@property (nonatomic,assign)NSInteger countDX;
@property (nonatomic,assign)NSInteger countLT;
@property (nonatomic,assign)NSInteger countYD;
@property (nonatomic,assign)NSInteger countTW;
@property (nonatomic,assign)NSInteger countCK;
@property (nonatomic,assign)NSInteger countBY;

@property (nonatomic,assign)NSInteger type;


@property (nonatomic,strong)NSString *rateMY;
@property (nonatomic,strong)NSString *rateDX;
@property (nonatomic,strong)NSString *rateLT;
@property (nonatomic,strong)NSString *rateYD;
@property (nonatomic,strong)NSString *rateTW;
@property (nonatomic,strong)NSString *rateCK;
@property (nonatomic,strong)NSString *rateBY;

@property (nonatomic,strong)NSString *roomName;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *updateTime;
@end
