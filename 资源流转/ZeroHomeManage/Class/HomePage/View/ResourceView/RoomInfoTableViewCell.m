//
//  RoomInfoTableViewCell.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "RoomInfoTableViewCell.h"

@implementation RoomInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(EquipMentListModel *)model
{
    self.count_lbl.text = [NSString stringWithFormat:@"总端口数:%ld 户",(long)model.count];
    self.userCount_lbl.text = [NSString stringWithFormat:@"总住户数:%ld 户",(long)model.userCount];
    NSInteger allCount = model.countDX + model.countYD +model.countLT + model.countCK +model.countTW;
    self.allUseCount_lbl.text = [NSString stringWithFormat:@"总装机数:%ld 户",(long)allCount];
    self.contDX_lbl.text = [NSString stringWithFormat:@"电信:%ld 户",(long)model.countDX];
    self.rateDX_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateDX];
    
    self.countYD_lbl.text = [NSString stringWithFormat:@"移动:%ld 户",(long)model.countYD];
    self.rateYD_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateYD];
    
    self.countLT_lbl.text = [NSString stringWithFormat:@"联通:%ld 户",(long)model.countLT];
    self.rateLT_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateLT];
    
    self.countCK_lbl.text = [NSString stringWithFormat:@"长宽:%ld 户",(long)model.countCK];
    self.rateCK_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateCK];
    
    self.countTW_lbl.text = [NSString stringWithFormat:@"通网:%ld 户",(long)model.countTW];
    self.rateTW_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateTW];
    
    self.beIyong_lbl.text = [NSString stringWithFormat:@"备用:%ld 户",(long)model.countBY];
    self.rateBY_lbl.text = [NSString stringWithFormat:@"占比:%@%%",model.rateBY];
}
@end
