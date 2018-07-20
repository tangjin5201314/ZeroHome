//
//  WorkAdminManageCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/15.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdminModel.h"
#import "TJsendPwBtn.h"

@protocol WorkAdminManageDelegate <NSObject>

- (void)clickAgreeWorkManageBtn:(NSInteger )index;
- (void)clickFaultWorkManageBtn:(NSInteger )index;
- (void)clickLiuzhuanWorkBtn:(NSInteger )index;
@end


@interface WorkAdminManageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title_lbl;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *tel_lbl;
@property (weak, nonatomic) IBOutlet UILabel *company_lbl;
@property (weak, nonatomic) IBOutlet UILabel *start_lbl;
@property (weak, nonatomic) IBOutlet UILabel *end_lbl;
@property (weak, nonatomic) IBOutlet TJsendPwBtn *workOrderBtn;

@property (weak, nonatomic) IBOutlet UILabel *reason_lbl;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *dilivi_view;

@property (weak, nonatomic) IBOutlet UIImageView *markImage;
@property (weak, nonatomic) IBOutlet UIView *dilivi_first;

@property (weak, nonatomic) IBOutlet UILabel *jieruhao_lbl;
@property (weak, nonatomic) IBOutlet UILabel *jierucard_lbl;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic,strong)AdminModel *adminModel;
@property(nonatomic,assign)float cellHeight;
@property (nonatomic,assign)NSInteger index;

@property (nonatomic,weak)id<WorkAdminManageDelegate>delegate;
@end
