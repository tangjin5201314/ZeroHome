//
//  SelectAreaCell.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "SelectAreaCell.h"

@implementation SelectAreaCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)selectAreaBtn:(UIButton *)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(selectAreaBtnTag:)]) {
        [_delegate selectAreaBtnTag:sender.tag];
    }

    
}



@end
