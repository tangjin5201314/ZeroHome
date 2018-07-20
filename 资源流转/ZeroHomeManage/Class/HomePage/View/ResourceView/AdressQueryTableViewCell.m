//
//  AdressQueryTableViewCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/5/24.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "AdressQueryTableViewCell.h"

@implementation AdressQueryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    [_adress_texfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

//- (void)textFieldDidChange:(UITextField *)textField
//{
//
//}

- (IBAction)clickQueryAdress:(UIButton *)sender {
    if (_delegage&&[_delegage respondsToSelector:@selector(textFieldEditChangeWithText:)]) {
        [_delegage textFieldEditChangeWithText:self.adress_texfield.text];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
