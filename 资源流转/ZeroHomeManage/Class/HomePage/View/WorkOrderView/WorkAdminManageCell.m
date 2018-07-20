//
//  WorkAdminManageCell.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/15.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkAdminManageCell.h"
#import "AdminModel.h"
#import "UIViewExt.h"
#import "AdminPhtoView.h"
#import "DataUtility.h"

@implementation WorkAdminManageCell
{
    AdminPhtoView *adminView;
     UIView *lastView;
    UILabel *result_lbl;
    UIButton *agreeBtn;
    UIButton *faulseBtn;
    UIView *separetView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    adminView = [[AdminPhtoView alloc]initWithMaxItemsCount:9];
    adminView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:adminView];
    
    lastView = [[UIView alloc]init];
//    lastView.backgroundColor = [UIColor greenColor];
    [self.contentView addSubview:lastView];
    
    result_lbl = [[UILabel alloc]init];
    result_lbl.font = Font(14);
    result_lbl.numberOfLines = 0;
    result_lbl.textColor = HexRGB(0x4facf6);
    result_lbl.text = @"反馈结果:";
    [lastView addSubview:result_lbl];
    
    separetView = [[UIView alloc]init];
    separetView.backgroundColor = HexRGB(0xc8c7cc);
    [lastView addSubview:separetView];
    
    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [agreeBtn setTitle:@"同意" forState:UIControlStateNormal];
    [agreeBtn setBackgroundImage:[UIImage imageNamed:@"rounder.png"] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(clickAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [agreeBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    agreeBtn.titleLabel.font = Font(14);
    [lastView addSubview:agreeBtn];
    
    faulseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faulseBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    [faulseBtn setBackgroundImage:[UIImage imageNamed:@"rounder.png"] forState:UIControlStateNormal];
    [faulseBtn addTarget:self action:@selector(ckickFaulseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [faulseBtn setTitleColor:HexRGB(0xffffff) forState:UIControlStateNormal];
    faulseBtn.titleLabel.font = Font(14);
    [lastView addSubview:faulseBtn];
    
//    self.topView.layer.borderColor = COLOR_RGB(200, 199, 204).CGColor;
//    self.topView.layer.borderWidth = 0.5;
    
    self.topView.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topEqualToView(self.contentView)
    .heightIs(29);
    
    self.title_lbl.sd_layout
    .leftSpaceToView(self.topView, 18)
    .topEqualToView(self.topView)
    .bottomEqualToView(self.topView);
    
    
    self.bottom_view.sd_layout
    .leftEqualToView(self.contentView)
    .rightEqualToView(self.contentView)
    .topSpaceToView(self.topView, 0.5)
    .heightIs(29);
    
    self.dilivi_first.sd_layout
    .topSpaceToView(self.bottom_view, 1)
    .leftSpaceToView(self.contentView, 18)
    .rightSpaceToView(self.contentView, 10)
    .heightIs(0.5);
    
    self.name_lbl.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(self.bottom_view,10)
    .widthIs(100)
//    .autoHeightRatio(0);
    .heightIs(21);
    
    self.tel_lbl.sd_layout
    .topSpaceToView(self.name_lbl,8)
    .leftEqualToView(self.name_lbl)
    .widthIs(100)
//    .autoHeightRatio(0);
    .heightIs(21);
    
    self.markImage.sd_layout
    .leftEqualToView(self.contentView)
    .topEqualToView(self.topView)
    .autoHeightRatio(1);
    
    self.start_lbl.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.bottom_view,10)
    .widthIs(132)
    .autoHeightRatio(0);
    
    self.end_lbl.sd_layout
    .rightSpaceToView(self.contentView,10)
    .bottomEqualToView(self.tel_lbl)
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
    .topSpaceToView(self.tel_lbl,10)
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
    
    lastView.sd_layout
    .leftEqualToView(self.name_lbl)
    .rightEqualToView(self.start_lbl);
    
    result_lbl.sd_layout
    .leftEqualToView(lastView)
    .rightEqualToView(lastView)
//    .autoHeightRatio(0)
    .heightIs(21)
    .topSpaceToView(lastView, 5);
    
    separetView.sd_layout
    .leftEqualToView(lastView)
    .rightEqualToView(lastView)
    .topSpaceToView(result_lbl, 5)
    .heightIs(0.5);
    
    agreeBtn.sd_layout
    .leftEqualToView(lastView)
    .topSpaceToView(separetView, 5)
//    .bottomSpaceToView(lastView, 5)
    .heightIs(35)
    .widthIs(100);
    
    faulseBtn.sd_layout
    .rightEqualToView(lastView)
    .topSpaceToView(separetView, 5)
    .heightIs(35)
//     .bottomSpaceToView(lastView, 5)
    .widthIs(100);
}

- (void)setAdminModel:(AdminModel *)adminModel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    switch (adminModel.workType) {
        case 1:{
            lastView.sd_layout
            .heightIs(71);
            agreeBtn.hidden = NO;
            faulseBtn.hidden = NO;
            self.workOrderBtn.hidden = NO;
            separetView.hidden = NO;
        }
            break;
        case 2:{
            lastView.sd_layout
            .heightIs(25);
            agreeBtn.hidden = YES;
            faulseBtn.hidden = YES;
            separetView.hidden = YES;
           }
            break;
         case 3:
            lastView.hidden = YES;
            lastView.sd_layout
            .heightIs(0);
            self.workOrderBtn.hidden = YES;
            break;

        default:
            break;
    }
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[adminModel.startTime doubleValue]/1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[adminModel.endTime doubleValue] / 1000];
    NSString *endDateStr = [dateFormatter stringFromDate: endDate];
    _jierucard_lbl.text = adminModel.workOrder;//接入号
    _name_lbl.text = adminModel.workerName;// 姓名
    _tel_lbl.text = adminModel.workerTel;//电话号码
    _title_lbl.text = adminModel.roomName;//机房名
    _start_lbl.text = startDateStr;//开始时间
    _end_lbl.text = endDateStr;//结束时间
    
    //营销流转资源后结果
    switch (adminModel.marketState) {
        case 1:
            result_lbl.text = @"反馈结果:用户同意撤单";
            break;
          case 2:
             result_lbl.text = @"反馈结果:用户同意缓装";
            break;
            case 3:
             result_lbl.text = @"反馈结果:策反失败请安装";
            break;
        default:
            result_lbl.text = @"反馈结果:";
            break;
    }
    
   
    switch (adminModel.state) {
        case 1:
            _markImage.image = [UIImage imageNamed:@"在审"];
            break;
        case 2:
            _markImage.image = [UIImage imageNamed:@"流转"];
            break;
        case 3:
            _markImage.image = [UIImage imageNamed:@"标签成功"];
            break;
        case 4:
            _markImage.image = [UIImage imageNamed:@"失败"];
            
            break;
        case 5:
            _markImage.image = [UIImage imageNamed:@"标签成功"];
            break;
        case 6:
            _markImage.image = [UIImage imageNamed:@"失败"];
            break;
        case 7:
            _markImage.image = [UIImage imageNamed:@"失败"];
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
  
    
    
    if ([DataUtility isBlankObject:adminModel.workerReason]) {
       _reason_lbl.text = [NSString stringWithFormat:@"说明:"] ;
    }else{
       _reason_lbl.text = [NSString stringWithFormat:@"说明: %@",adminModel.workerReason] ;
    }
    [self setTimeoutCellContentBackviewWithModel:adminModel];
    
    UIView *bottomView;
    NSArray *imagesArray = [adminModel.imageOrder componentsSeparatedByString:@","];
    NSMutableArray *imageMutableArray = [NSMutableArray arrayWithArray:imagesArray];
    [adminView setPhotoNamesArray:imageMutableArray];
    if (adminModel.imageOrder.length>0) {
        adminView.hidden = NO;
//        bottomView = adminView;
        lastView.sd_layout
        .topSpaceToView(adminView, 10);
    }else{
        adminView.hidden = YES;
        lastView.sd_layout
        .topSpaceToView(self.reason_lbl, 10);
    }
    bottomView = lastView;
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:5];
//    [self.superview layoutIfNeeded];
    //    [self setupAutoHeightWithBottomViewsArray:@[_reason_lbl,adminView] bottomMargin:10];
    
}

- (void)layoutSubviews
{
    [self layoutIfNeeded];
}

- (void)setTimeoutCellContentBackviewWithModel:(AdminModel *)model
{
    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
    if ([model.endTime doubleValue]<[startTime doubleValue]) {
        self.backgroundColor = HexRGB(0xf6f6f6);
        _name_lbl.textColor = HexRGB(0x999999);
        _tel_lbl.textColor = HexRGB(0x999999);
        _company_lbl.textColor = HexRGB(0x999999);
        _reason_lbl.textColor = HexRGB(0x999999);
        _start_lbl.textColor = HexRGB(0x999999);
        _end_lbl.textColor = HexRGB(0x999999);
        adminView.backgroundColor = HexRGB(0xf6f6f6);
        self.bottom_view.backgroundColor = HexRGB(0xf6f6f6);
        self.jieruhao_lbl.textColor = HexRGB(0x999999);
        agreeBtn.enabled = NO;
        faulseBtn.enabled = NO;
        self.workOrderBtn.enabled = NO;
    }else{
        self.backgroundColor = HexRGB(0xffffff);
        _name_lbl.textColor = HexRGB(0x333333);
        _tel_lbl.textColor = HexRGB(0x999999);
        _company_lbl.textColor = HexRGB(0x333333);
        _reason_lbl.textColor = HexRGB(0x333333);
        _start_lbl.textColor = HexRGB(0x333333);
        _end_lbl.textColor = HexRGB(0x333333);
        adminView.backgroundColor = HexRGB(0xffffff);
        self.bottom_view.backgroundColor = HexRGB(0xffffff);
        self.jieruhao_lbl.textColor = HexRGB(0x333333);
        agreeBtn.enabled = YES;
        faulseBtn.enabled = YES;
        self.workOrderBtn.enabled = YES;
    }
}

- (IBAction)gongdanCicleBtn:(UIButton *)sender {
    if (self.delegate &&[self.delegate respondsToSelector:@selector(clickLiuzhuanWorkBtn:)]) {
        [self.delegate clickLiuzhuanWorkBtn:self.index];
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

- (void)clickAgreeBtn:(UIButton *)btn
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickAgreeWorkManageBtn:)]) {
        [self.delegate clickAgreeWorkManageBtn:self.index];
    }
}

- (void)ckickFaulseBtn:(UIButton *)btn
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(clickFaultWorkManageBtn:)]) {
        [self.delegate clickFaultWorkManageBtn:self.index];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
