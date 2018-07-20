//
//  ResoucecirCulationCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "ResoucecirCulationCell.h"

@implementation ResoucecirCulationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectUserName:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSelectUserBtn:)]) {
        [self.delegate clickSelectUserBtn:sender];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
