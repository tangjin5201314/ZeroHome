//
//  MangeRoomListCell.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "MangeRoomListCell.h"

@implementation MangeRoomListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(EquipMentListModel *)model
{
    _jigui_lbl.text = [NSString stringWithFormat:@"机柜-%@",model.equipmentCode]; 
}

@end
