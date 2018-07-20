//
//  PortInfoModel.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/28.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PortInfoModel : NSObject
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *equipmentCode;
@property (nonatomic,strong)NSString *equipmentId;
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,strong)NSString *roomCode;
@property (nonatomic,strong)NSString *roomId;
@property (nonatomic,strong)NSString *roomName;
@property (nonatomic,strong)NSArray *roomPortVOs;

@end
