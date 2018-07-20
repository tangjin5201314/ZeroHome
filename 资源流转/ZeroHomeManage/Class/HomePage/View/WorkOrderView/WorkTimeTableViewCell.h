//
//  WorkTimeTableViewCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutheTimeListModel.h"


@interface WorkTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *start_lbl;
@property (weak, nonatomic) IBOutlet UILabel *end_lbl;
@property (weak, nonatomic) IBOutlet UIView *topSeperateView;
@property (weak, nonatomic) IBOutlet UILabel *workOder_lbl;

@property (weak, nonatomic) IBOutlet UILabel *startDate_lbl;
@property (weak, nonatomic) IBOutlet UILabel *startTime_lbl;
@property (weak, nonatomic) IBOutlet UILabel *endDate_lbl;
@property (weak, nonatomic) IBOutlet UILabel *endTime_lbl;
@property (weak, nonatomic) IBOutlet UIImageView *mark_image;
@property (weak, nonatomic) IBOutlet UIView *divid_line;

@property (weak, nonatomic) IBOutlet UIView *bottom_view;

@property (nonatomic,strong)UIView *bottomSeperaView ;
@property (nonatomic,strong)UIView *topSeperaView;
@property (nonatomic,assign)CGFloat cellHeight;
@property (nonatomic,strong)AutheTimeListModel *listModel;
@end
