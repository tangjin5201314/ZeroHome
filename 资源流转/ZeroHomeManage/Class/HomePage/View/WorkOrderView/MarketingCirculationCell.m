//
//  MarketingCirculationCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "MarketingCirculationCell.h"

@implementation MarketingCirculationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)selectReasonBtn:(UIButton *)sender {
    for(int i = 0;i<3;i++)
    {
        if (sender.tag == 1000+i) {
            sender.selected = YES;
//            [sender setImage:[UIImage imageNamed:@"Selectedadd.png"] forState:UIControlStateSelected];
            self.block(i+1);
            continue;
        }
        UIButton *btn = (UIButton *)[self viewWithTag:1000 + i];
            btn.selected = NO;
//        [sender setImage:[UIImage imageNamed:@"UnSelected.png"] forState:UIControlStateSelected];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
