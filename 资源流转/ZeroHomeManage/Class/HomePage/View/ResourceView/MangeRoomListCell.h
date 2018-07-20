//
//  MangeRoomListCell.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EquipMentListModel.h"

@interface MangeRoomListCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *jigui_lbl;
@property (nonatomic,strong)EquipMentListModel *model;
@end
