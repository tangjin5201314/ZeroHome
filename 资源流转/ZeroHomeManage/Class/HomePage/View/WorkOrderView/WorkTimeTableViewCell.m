//
//  WorkTimeTableViewCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkTimeTableViewCell.h"
#import "DataUtility.h"

@interface WorkTimeTableViewCell ()
@end

@implementation WorkTimeTableViewCell
{
    UIView *failView;
    UILabel *reason_lbl;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    _topSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    _topSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
//    [self addSubview:_topSeperaView];
    self.topSeperaView.height = 0.5;
    _bottomSeperaView = [[UIView alloc]init];
    _bottomSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
    [self addSubview:_bottomSeperaView];
    
    [_bottomSeperaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(@0.5);
    }];
    self.divid_line.height = 0.5;
    self.topSeperaView.height = 0.5;
    
    failView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
    [self.contentView addSubview:failView];
    UIView *failDivisView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    failDivisView.backgroundColor = COLOR_RGB(200, 199, 204);
    [failView addSubview:failDivisView];
    
    reason_lbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 6, SCREEN_WIDTH-36, 0)];
    reason_lbl.text = @"原因说明";
    
    reason_lbl.textColor = HexRGB(0x4facf6);
    reason_lbl.font = Font(12);
    reason_lbl.numberOfLines = 0;
    [failView addSubview:reason_lbl];
    
}


- (void)setListModel:(AutheTimeListModel *)listModel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[listModel.startTime doubleValue] / 1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    NSArray *startDate = [startDateStr componentsSeparatedByString:@" "];
    
    NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:[listModel.endTime doubleValue] / 1000];
    NSString *endDateStr = [dateFormatter stringFromDate: enddate];
    NSArray *endDate = [endDateStr componentsSeparatedByString:@" "];
    _workOder_lbl.text = listModel.workOrder;
   
    _startDate_lbl.text = startDate[0];
    _startTime_lbl.text = startDate[1];
    _endDate_lbl.text = endDate[0];
    _endTime_lbl.text = endDate[1];
    
    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
   
    switch (listModel.state) {
        case 1:
        {
            if ([listModel.endTime doubleValue]<[startTime doubleValue])
            {
                reason_lbl.text = [NSString stringWithFormat:@"原因说明:请联系资源现场管理员"];
                failView.top = _endDate_lbl.bottom+11;
                _mark_image.image = [UIImage imageNamed:@"失败"];
                CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
                
                failView.height = reaSonSize.height+15;
                reason_lbl.height = reaSonSize.height+4;
                _bottom_view.top = failView.bottom;
                _cellHeight = _bottom_view.bottom;
            }else{
                _mark_image.image = [UIImage imageNamed:@"在审"];
                [failView removeFromSuperview];
                _bottom_view.bottom = self.contentView.bottom;
                _cellHeight = _bottom_view.bottom;
            }
           
        }
            break;
        case 2:
        {
            if ([listModel.endTime doubleValue]<[startTime doubleValue])
            {
                reason_lbl.text = [NSString stringWithFormat:@"原因说明:请联系资源现场管理员"];
                failView.top = _endDate_lbl.bottom+11;
                _mark_image.image = [UIImage imageNamed:@"失败"];
                CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
                
                failView.height = reaSonSize.height+15;
                reason_lbl.height = reaSonSize.height+4;
                _bottom_view.top = failView.bottom;
                _cellHeight = _bottom_view.bottom;
            }else{
                _mark_image.image = [UIImage imageNamed:@"流转"];
                [failView removeFromSuperview];
                _bottom_view.bottom = self.contentView.bottom;
                _cellHeight = _bottom_view.bottom;
            }
            
        }
            break;
        case 3:
        {
            if ([listModel.endTime doubleValue]<[startTime doubleValue])
            {
                reason_lbl.text = [NSString stringWithFormat:@"原因说明:请联系资源现场管理员"];
                failView.top = _endDate_lbl.bottom+11;
                _mark_image.image = [UIImage imageNamed:@"失败"];
                CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
                
                failView.height = reaSonSize.height+15;
                reason_lbl.height = reaSonSize.height+4;
                _bottom_view.top = failView.bottom;
                _cellHeight = _bottom_view.bottom;
            }else{
                _mark_image.image = [UIImage imageNamed:@"流转"];
                [failView removeFromSuperview];
                _bottom_view.bottom = self.contentView.bottom;
                _cellHeight = _bottom_view.bottom;
            }
            
        }
            break;
        case 4:
        {
            failView.top = _endDate_lbl.bottom+11;
            _mark_image.image = [UIImage imageNamed:@"失败"];
//            NSString *reason;
//            if ([DataUtility isBlankObject:listModel.workerReason]) {
//                reason = @"";
//            }else{
//                reason = listModel.workerReason;
//            }
            reason_lbl.text = [NSString stringWithFormat:@"原因说明:%@",@"联系用户已撤单,审批拒绝"];
            
            CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
            
            failView.height = reaSonSize.height+15;
            reason_lbl.height = reaSonSize.height+4;
            _bottom_view.top = failView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
            case 5:
        {
            failView.top = _endDate_lbl.bottom+11;
            _mark_image.image = [UIImage imageNamed:@"标签成功"];
            reason_lbl.text = [NSString stringWithFormat:@"原因说明:%@",@"跳纤已完成,请装机.审批通过"];
            
            CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
            
            failView.height = reaSonSize.height+15;
            reason_lbl.height = reaSonSize.height+4;
            _bottom_view.top = failView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
        case 6:
        {
            failView.top = _endDate_lbl.bottom+11;
            _mark_image.image = [UIImage imageNamed:@"失败"];

            reason_lbl.text = [NSString stringWithFormat:@"原因说明:%@",@"线路故障需施工队处理,审批拒绝"];
            
            CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
            
            failView.height = reaSonSize.height+15;
            reason_lbl.height = reaSonSize.height+4;
            _bottom_view.top = failView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
         case 7:
        {
            failView.top = _endDate_lbl.bottom+11;
            _mark_image.image = [UIImage imageNamed:@"失败"];
            reason_lbl.text = [NSString stringWithFormat:@"原因说明:%@",@"线路故障需施工队处理,审批拒绝"];
            
            CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
            
            failView.height = reaSonSize.height+15;
            reason_lbl.height = reaSonSize.height+4;
            _bottom_view.top = failView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
        default:
            break;
    }

     if ([listModel.endTime doubleValue]<[startTime doubleValue]) {
     self.backgroundColor = HexRGB(0xf6f6f6);
     self.start_lbl.textColor = HexRGB(0x999999);
     self.end_lbl.textColor = HexRGB(0x999999);
     self.startDate_lbl.textColor = HexRGB(0x999999);
     self.startTime_lbl.textColor = HexRGB(0x999999);
     self.endDate_lbl.textColor = HexRGB(0x999999);
     self.endTime_lbl.textColor = HexRGB(0x999999);
     }
    
    
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

//字符串转时间戳
- (NSString *)stringConversionDateTime:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:zone];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
