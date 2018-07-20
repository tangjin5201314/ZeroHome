//
//  PanelInfoMationController.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EquipMentListModel.h"

@interface PanelInfoMationController : BaseViewController
@property (nonatomic,strong)EquipMentListModel *infoModel;
@property (nonatomic,strong)NSString *roomId;
@property (nonatomic,getter=isChangePort)BOOL changePort;
//@property (nonatomic,strong)NSArray *savePortArray;
@property (nonatomic,strong)NSArray *indicatorArray;

@end
