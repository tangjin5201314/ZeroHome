//
//  AdminAuthouTableViewCell.m
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import "AdminAuthouTableViewCell.h"
#import "AdminModel.h"
#import "UIViewExt.h"
#import "AdminPhtoView.h"

@implementation AdminAuthouTableViewCell
{
    AdminPhtoView *adminView;
    UIView *lastView;
}


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    adminView = [[AdminPhtoView alloc]initWithMaxItemsCount:9];
    adminView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:adminView];

    
    self.bottom_view.layer.borderColor = COLOR_RGB(200, 199, 204).CGColor;
    self.bottom_view.layer.borderWidth = 0.5;
    
    self.bottom_view.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(29);
    
    self.name_lbl.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(self.bottom_view,10)
    .widthIs(100)
    .autoHeightRatio(0);
    
    self.tel_lbl.sd_layout
    .topSpaceToView(self.name_lbl,8)
    .leftEqualToView(self.name_lbl)
    .widthIs(100)
    .autoHeightRatio(0);
    
    self.markImage.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.bottom_view,-1)
    .autoHeightRatio(1);
    
    self.start_lbl.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.bottom_view,10)
    .widthIs(132)
    .autoHeightRatio(0);
    
    self.end_lbl.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.start_lbl,8)
    .widthIs(132)
    .autoHeightRatio(0);
    
    self.company_lbl.sd_layout
    .topSpaceToView(self.bottom_view,15)
    .leftSpaceToView(self.tel_lbl,2)
    .rightSpaceToView(self.end_lbl,2);
//    .widthIs(50);

    self.dilivi_view.sd_layout
    .leftEqualToView(self.name_lbl)
    .rightEqualToView(self.end_lbl)
    .topSpaceToView(self.end_lbl,10)
    .heightIs(0.5);
    
    self.reason_lbl.sd_layout
    .leftEqualToView(self.name_lbl)
    .topSpaceToView(self.dilivi_view,10)
    .rightEqualToView(self.start_lbl)
    .autoHeightRatio(0);
    
    adminView.sd_layout
    .leftEqualToView(self.name_lbl)
    .rightEqualToView(self.start_lbl)
    .topSpaceToView(self.reason_lbl,10);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//发送密码
- (IBAction)sendPassWord:(UIButton *)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(adminAuthouSendPassWordBtn:)]) {
        [_delegate adminAuthouSendPassWordBtn:self];
    }
    
}


- (void)setAdminModel:(AdminModel *)adminModel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

        _name_lbl.text = adminModel.realName;
        _tel_lbl.text = adminModel.tel;
        _title_lbl.text = adminModel.room_name;
        switch (adminModel.checkOrder) {
            case 1:
                _markImage.image = [UIImage imageNamed:@"标签成功"];
                break;
             case 2:
                _markImage.image = [UIImage imageNamed:@"失败"];
                break;
                case 3:
                _markImage.image = [UIImage imageNamed:@"标签成功"];
                break;
                case 4:
                _markImage.image = [UIImage imageNamed:@"在审"];
                break;
            default:
                break;
        }
        
        switch (adminModel.type) {
            case 1:
                _company_lbl.text = @"通网";
                break;
            case 2:
                _company_lbl.text = @"电信";
                break;
            case 3:
                _company_lbl.text = @"联通";
                break;
            case 4:
                _company_lbl.text = @"移动";
                break;
            case 5:
                _company_lbl.text = @"长城";
                break;
            case 6:
                _company_lbl.text = @"管理员";
                break;
            case 7:
                _company_lbl.text = @"物业";
                break;
            case 8:
                _company_lbl.text = @"营销员";
                break;
            case 9:
                _company_lbl.text = @"领导";
                break;
            default:
                break;
        }
        
        NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[adminModel.startTime doubleValue]/1000];
        NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    
        NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[adminModel.endTime doubleValue] / 1000];
        NSString *endDateStr = [dateFormatter stringFromDate: endDate];
   
      _start_lbl.text = startDateStr;
       _end_lbl.text = endDateStr;
    _adminModel = adminModel;
    _reason_lbl.text = [NSString stringWithFormat:@"说明:%@",adminModel.reason] ;
    UIView *bottomView = _reason_lbl;
    
    NSArray *imagesArray = [adminModel.imageOrder componentsSeparatedByString:@","];
    NSMutableArray *imageMutableArray = [NSMutableArray arrayWithArray:imagesArray];
    [adminView setPhotoNamesArray:imageMutableArray];
    if (adminModel.imageOrder.length>0) {
        adminView.hidden = NO;
        bottomView = adminView;

    }else{
        adminView.hidden = YES;

    }
    if (adminModel.checkOrder == 4||adminModel.checkOrder == 2) {
        self.sendPawordBtn.enabled = NO;
         self.sendPawordBtn.selected = NO;
    }else{
        self.sendPawordBtn.enabled = YES;
        self.sendPawordBtn.selected = YES;
    }
    

    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
    if ([adminModel.endTime doubleValue]<[startTime doubleValue]) {
        self.backgroundColor = HexRGB(0xf6f6f6);
        _name_lbl.textColor = HexRGB(0x999999);
        _tel_lbl.textColor = HexRGB(0x999999);
        _company_lbl.textColor = HexRGB(0x999999);
        _reason_lbl.textColor = HexRGB(0x999999);
        _start_lbl.textColor = HexRGB(0x999999);
        _end_lbl.textColor = HexRGB(0x999999);
        adminView.backgroundColor = HexRGB(0xf6f6f6);
    }else{
        self.backgroundColor = HexRGB(0xffffff);
        _name_lbl.textColor = HexRGB(0x333333);
        _tel_lbl.textColor = HexRGB(0x999999);
        _company_lbl.textColor = HexRGB(0x333333);
        _reason_lbl.textColor = HexRGB(0x333333);
        _start_lbl.textColor = HexRGB(0x333333);
        _end_lbl.textColor = HexRGB(0x333333);
        adminView.backgroundColor = HexRGB(0xffffff);
    }

    
    
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
//    [self setupAutoHeightWithBottomViewsArray:@[_reason_lbl,adminView] bottomMargin:10];
    
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


@end
