//
//  AdminAuthouCell.h
//  ZeroHome
//
//  Created by TW on 17/1/9.
//  Copyright © 2017年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdminModel;
@interface AdminAuthouCell : UITableViewCell
@property (nonatomic,strong)AdminModel *adminModel;
@property (weak, nonatomic) IBOutlet UILabel *titleName;

@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *tel_lbl;
@property (weak, nonatomic) IBOutlet UILabel *company_lbl;
@property (weak, nonatomic) IBOutlet UILabel *start_lbl;
@property (weak, nonatomic) IBOutlet UILabel *end_lbl;

@property (weak, nonatomic) IBOutlet UILabel *reason_lbl;
@property (weak, nonatomic) IBOutlet UIView *dilivi_view;

@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@end
