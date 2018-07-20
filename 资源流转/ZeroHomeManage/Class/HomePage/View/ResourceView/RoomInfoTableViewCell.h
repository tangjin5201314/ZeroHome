//
//  RoomInfoTableViewCell.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipMentListModel.h"
@interface RoomInfoTableViewCell : UITableViewCell
@property (nonatomic,strong)EquipMentListModel *model;

@property (weak, nonatomic) IBOutlet UILabel *count_lbl;
@property (weak, nonatomic) IBOutlet UILabel *allUseCount_lbl;
@property (weak, nonatomic) IBOutlet UILabel *userCount_lbl;
@property (weak, nonatomic) IBOutlet UILabel *contDX_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateDX_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countYD_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateYD_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countLT_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateLT_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countCK_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateCK_lbl;
@property (weak, nonatomic) IBOutlet UILabel *countTW_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateTW_lbl;
@property (weak, nonatomic) IBOutlet UILabel *beIyong_lbl;
@property (weak, nonatomic) IBOutlet UILabel *rateBY_lbl;

@end
