//
//  AuthorizdTimeTableViewCell.m
//  ZeroHome
//
//  Created by TW on 16/11/29.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "AuthorizdTimeTableViewCell.h"
#import "UIViewExt.h"

@implementation AuthorizdTimeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    for(UIView *divid_view in _divid_line)
    {
        divid_view.height = 0.5;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
