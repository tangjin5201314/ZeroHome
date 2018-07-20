//
//  smallAreaTableViewCell.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "smallAreaTableViewCell.h"

@implementation smallAreaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setSmallAreaModel:(smallAreaModel *)SmallAreaModel{
    self.AreaName.text = SmallAreaModel.branchName;
    self.adress.text = SmallAreaModel.address;
}

@end
