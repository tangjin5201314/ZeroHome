//
//  SettingTableViewCell.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "SettingTableViewCell.h"

@implementation SettingTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.contentView addSubview:_line];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
