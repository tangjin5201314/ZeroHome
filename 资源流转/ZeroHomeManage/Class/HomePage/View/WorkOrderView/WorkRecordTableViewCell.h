//
//  WorkRecordTableViewCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/12.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutheTimeListModel.h"

@interface WorkRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jieruhao_lbl;
@property (weak, nonatomic) IBOutlet UILabel *useName_lbl;
@property (weak, nonatomic) IBOutlet UILabel *workType_lbl;
@property (weak, nonatomic) IBOutlet UILabel *startTime_lbl;
@property (weak, nonatomic) IBOutlet UILabel *endTime_lbl;
@property (nonatomic,strong)AutheTimeListModel *listModel;
@end
