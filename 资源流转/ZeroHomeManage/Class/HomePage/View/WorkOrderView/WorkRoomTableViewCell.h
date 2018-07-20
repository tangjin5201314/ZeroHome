//
//  WorkRoomTableViewCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/15.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutheTimeListModel.h"

@interface WorkRoomTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *motorRoom_field;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;
@property (weak, nonatomic) IBOutlet UILabel *youxiaoTime_lbl;
@property (weak, nonatomic) IBOutlet UIButton *seachInfoBtn;
@property (nonatomic,strong) AutheTimeListModel *model;
@end
