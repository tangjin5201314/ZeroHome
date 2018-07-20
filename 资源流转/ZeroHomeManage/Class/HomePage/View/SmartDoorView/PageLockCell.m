//
//  PageLockCell.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/10.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "PageLockCell.h"

@implementation PageLockCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)lockRoowBtn:(UIButton *)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(keyLockBtn)]) {
        [_delegate keyLockBtn];
    }
    
}



@end
