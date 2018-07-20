//
//  OutSiderAuthorizeTimeCell.m
//  ZeroHome
//
//  Created by TW on 16/12/1.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "OutSiderAuthorizeTimeCell.h"
#import "UIViewExt.h"


@implementation OutSiderAuthorizeTimeCell
{
    UIView *failView;
    UILabel *reason_lbl;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _topSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    _topSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
    [self addSubview:_topSeperaView];
    
    _bottomSeperaView = [[UIView alloc]init];
    _bottomSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
    [self addSubview:_bottomSeperaView];
    
    [_bottomSeperaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(@0.5);
    }];
    
    failView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 0)];
    [self.contentView addSubview:failView];
    UIView *failDivisView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    failDivisView.backgroundColor = COLOR_RGB(200, 199, 204);
    [failView addSubview:failDivisView];
    
    reason_lbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 0)];
    reason_lbl.text = @"原因说明";
    reason_lbl.textColor = HexRGB(0x4facf6);
    reason_lbl.font = Font(12);
    reason_lbl.numberOfLines = 0;
    [failView addSubview:reason_lbl];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    
    _startDate_lbl.text = startDate[0];
    _startTime_lbl.text = startDate[1];
    _endDate_lbl.text = endDate[0];
    _endTime_lbl.text = endDate[1];
    
    switch (listModel.checkOrder) {
        case 1:
        {
            _mark_image.image = [UIImage imageNamed:@"标签成功"];
            [failView removeFromSuperview];
            _bottom_view.bottom = self.contentView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
         case 2:
        {
            failView.top = _endDate_lbl.bottom+11;
            _mark_image.image = [UIImage imageNamed:@"失败"];
            reason_lbl.text = [NSString stringWithFormat:@"原因说明:%@",listModel.failReason];

            CGSize reaSonSize = [reason_lbl.text boundingRectWithSize:CGSizeMake(reason_lbl.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:Font(12)} context:nil].size;
            
            failView.height = reaSonSize.height+4;
            reason_lbl.height = reaSonSize.height;
            _bottom_view.top = failView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
            case 3:
        {
            _mark_image.image = [UIImage imageNamed:@"标签成功"];
            _bottom_view.bottom = self.contentView.bottom;
            _cellHeight = _bottom_view.bottom;
        }
            break;
            case 4:
        {
             [failView removeFromSuperview];
            _bottom_view.bottom = self.contentView.bottom;
             _mark_image.image = [UIImage imageNamed:@"在审"];
            _cellHeight = _bottom_view.bottom;
        }
           
            break;
        default:
            break;
    }
    
}

@end
