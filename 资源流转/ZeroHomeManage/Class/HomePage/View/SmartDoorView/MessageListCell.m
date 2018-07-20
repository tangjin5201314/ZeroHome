//
//  MessageListCell.m
//  ZeroHome
//
//  Created by TW on 16/11/30.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "MessageListCell.h"
#import "DataUtility.h"

@implementation MessageListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setLockModel:(OpenLockModel *)lockModel
{
    _lockModel = lockModel;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[_lockModel.op_time doubleValue] / 1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    _thrd_lbl.text = startDateStr;
    _first_lbl.text = _lockModel.user_name;
    _usePhone_lbl.text = _lockModel.user_mobile;

    
    switch (_lockModel.op_way) {
        case 0:
            _second_lbl.text = @"APP开锁";
            break;
        case 1:
            _second_lbl.text = @"自定义密码";
            break;
        case 2:
            _second_lbl.text = @"一次性密码开锁";
            break;
        case 4:
            _second_lbl.text = @"时效密码开锁";
            break;
        default:
            break;
    }

}



@end
