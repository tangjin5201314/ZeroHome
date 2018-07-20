//
//  AdminAuthouCell.m
//  ZeroHome
//
//  Created by TW on 17/1/9.
//  Copyright © 2017年 deguang. All rights reserved.
//

#import "AdminAuthouCell.h"
#import "AdminModel.h"
#import "UIViewExt.h"
#import "AdminPhtoView.h"
@implementation AdminAuthouCell
{
    AdminPhtoView *adminView;
}

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    _dilivi_view.height = 0.5f;
    
    adminView = [[AdminPhtoView alloc]initWithMaxItemsCount:9];
    adminView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:adminView];
    
    self.titleName.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(self.contentView,10)
    .widthIs(200);
    
    self.name_lbl.sd_layout
    .leftSpaceToView(self.contentView,18)
    .topSpaceToView(self.titleName,1)
    .widthIs(100);

    self.tel_lbl.sd_layout
    .topSpaceToView(self.name_lbl,8)
    .leftEqualToView(self.name_lbl)
    .widthIs(100);

    self.markImage.sd_layout
    .leftEqualToView(self.contentView)
    .topSpaceToView(self.contentView,-1);
    
    self.start_lbl.sd_layout
    .rightSpaceToView(self.contentView,10)
    .topSpaceToView(self.titleName,1)
    .widthIs(132);
    
    self.end_lbl.sd_layout
    .rightSpaceToView(self.contentView,10)
    .bottomEqualToView(self.tel_lbl)
    .widthIs(132);
  
    self.company_lbl.sd_layout
    .topSpaceToView(self.titleName,20)
    .leftSpaceToView(self.tel_lbl,2)
    .rightSpaceToView(self.end_lbl,2);
//    .widthIs(50);

    self.dilivi_view.sd_layout
    .leftEqualToView(self.name_lbl)
    .rightEqualToView(self.start_lbl)
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

}

- (void)setAdminModel:(AdminModel *)adminModel
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    _titleName.text = adminModel.room_name;
    _name_lbl.text = adminModel.realName;
    _tel_lbl.text = adminModel.tel;
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
        default:
            break;
    }
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[adminModel.startTime doubleValue] / 1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[adminModel.endTime doubleValue] / 1000];
    NSString *endDateStr = [dateFormatter stringFromDate: endDate];
    
    _start_lbl.text = startDateStr;
    _end_lbl.text = endDateStr;

    
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
    
    [self setupAutoHeightWithBottomView:bottomView bottomMargin:10];
    //    [self setupAutoHeightWithBottomViewsArray:@[_reason_lbl,adminView] bottomMargin:10];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
