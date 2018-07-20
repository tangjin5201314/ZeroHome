//
//  RoomPortModel.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/28.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RoomPortModel : NSObject
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *updateTime;
@property (nonatomic,strong)NSString *equipmentId;
@property (nonatomic,assign)NSInteger isDelete;
@property (nonatomic,assign)NSInteger ID;
//@property (nonatomic,strong)NSString *newB;
@property (nonatomic,strong)NSString *oldA;
@property (nonatomic,strong)NSString *nowA;
@property (nonatomic,assign)NSInteger portSort;
@property (nonatomic,assign)NSInteger portType;
@property (nonatomic,assign)NSInteger roomId;
@property (nonatomic,assign)NSInteger trayId;
@end
