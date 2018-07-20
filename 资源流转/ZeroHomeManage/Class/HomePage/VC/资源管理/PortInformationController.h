//
//  PortInformationController.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/26.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "RoomPortModel.h"
#import "EquipMentListModel.h"

typedef void(^callBackOperateBlock)(NSInteger operateType,NSInteger oldPortID,NSInteger userID,BOOL isChangePort) ;
@interface PortInformationController : BaseViewController
@property (nonatomic,strong)RoomPortModel *roomPortModel; //机房端口model
@property (nonatomic,strong)EquipMentListModel *infoModel;
@property (nonatomic,strong)NSIndexPath *indexPath;
@property (nonatomic,assign)NSInteger section;
@property (nonatomic,assign)NSInteger row;

@property (nonatomic,copy)callBackOperateBlock callBackBlock;

@end
