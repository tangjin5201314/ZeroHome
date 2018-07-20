//
//  PushNewListCell.m
//  ZeroHome
//
//  Created by TW on 16/12/19.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "PushNewListCell.h"

@implementation PushNewListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPushModel:(NewPushModel *)pushModel
{
    _pushModel = pushModel;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[_pushModel.time doubleValue] / 1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    _thrd_lbl.text = startDateStr;
    
    _second_lbl.text = _pushModel.details;
    if ([_pushModel.event isEqualToString:@"PUSH_LOCK_OFFLINE"]) {
        _first_lbl.text = @"门锁离线提醒";
    }else if ([_pushModel.event isEqualToString:@"PUSH_LOCK_SET_PWD_SUCCESS"]){
        _first_lbl.text = @"密码设置成功";
    }else if ([_pushModel.event isEqualToString:@"PUSH_LOCK_SET_PWD_FALL"]){
        _first_lbl.text = @"密码设置失败";
    }else if ([_pushModel.event isEqualToString:@"PUSH_LOCK_POWRE_LOW"]){
        _first_lbl.text = @"电池电量低";
    }else if ([_pushModel.event isEqualToString:@"PUSH_LOCK_POWRE_RECOVERY"]){
        _first_lbl.text = @"电池电量恢复";
    }else if ([_pushModel.event isEqualToString:@"PUSH_OPEN_LOCK"]){
        _first_lbl.text = @"开锁提醒";
    }else if ([_pushModel.event isEqualToString:@"PUSH_LOCK_ONLINE"]){
        _first_lbl.text = @"门锁在线提醒";
    }else if ([_pushModel.event isEqualToString:@"PUSH_NODE_ONLINE"]){
        _first_lbl.text = @"网关在线提醒";
    }else if ([_pushModel.event isEqualToString:@"PUSH_NODE_OFFLINE"]){
        _first_lbl.text = @"网关离线提醒";
    }else if ([_pushModel.event isEqualToString:@"CUSTOM"]){
        _first_lbl.text = @"管理平台消息";
    }
    
}


@end
