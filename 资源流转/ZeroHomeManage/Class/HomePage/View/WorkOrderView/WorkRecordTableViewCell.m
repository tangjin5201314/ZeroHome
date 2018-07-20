//
//  WorkRecordTableViewCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/12.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkRecordTableViewCell.h"

@implementation WorkRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setListModel:(AutheTimeListModel *)listModel
{
    self.jieruhao_lbl.text = listModel.workOrder;
    self.useName_lbl.text = listModel.workerName;
    switch (listModel.state) {
        case 1:
            self.workType_lbl.text = @"工单正在处理中";
            break;
        case 2:
            self.workType_lbl.text = @"工单正在处理中";
            break;
        case 3:
            self.workType_lbl.text = @"工单正在处理中";
            break;
        case 4:
            self.workType_lbl.text = @"联系用户已撤单,审批拒绝";
            break;
        case 5:
            self.workType_lbl.text = @"跳纤已完成,请装机。审批通过";
            break;
        case 6:
            self.workType_lbl.text = @"线路故障需施工队处理,审批拒绝";
            break;
        case 7:
            self.workType_lbl.text = @"其他,请联系机房现场管理员";
            break;
        default:
            break;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[listModel.startTime doubleValue] / 1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    self.startTime_lbl.text = startDateStr;
    NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:[listModel.endTime doubleValue] / 1000];
    NSString *endDateStr = [dateFormatter stringFromDate: enddate];
    self.endTime_lbl.text = endDateStr;
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
