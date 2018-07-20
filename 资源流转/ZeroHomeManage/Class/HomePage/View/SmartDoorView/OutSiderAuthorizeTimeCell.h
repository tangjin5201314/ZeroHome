//
//  OutSiderAuthorizeTimeCell.h
//  ZeroHome
//
//  Created by TW on 16/12/1.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutheTimeListModel.h"

@interface OutSiderAuthorizeTimeCell : UITableViewCell
@property (nonatomic,strong)AutheTimeListModel *listModel;
@property (weak, nonatomic) IBOutlet UILabel *start_lbl;
@property (weak, nonatomic) IBOutlet UILabel *end_lbl;

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
@end
