//
//  WorkRoomTableViewCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/15.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkRoomTableViewCell.h"

@implementation WorkRoomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(AutheTimeListModel *)model
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[model.startTime doubleValue] / 1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
//    NSArray *startDate = [startDateStr componentsSeparatedByString:@" "];
    
    NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:[model.endTime doubleValue] / 1000];
    NSString *endDateStr = [dateFormatter stringFromDate: enddate];
    self.youxiaoTime_lbl.text = [NSString stringWithFormat:@"有效时间：%@-%@",startDateStr,endDateStr];
//    NSArray *endDate = [endDateStr componentsSeparatedByString:@" "];
}

@end
