//
//  AdminAuthouTableViewCell.h
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdminModel;
@class AdminAuthouTableViewCell;

@protocol adminAuthouSendPawordDelegate <NSObject>

- (void)adminAuthouSendPassWordBtn:(AdminAuthouTableViewCell *)adminCell;

@end

@interface AdminAuthouTableViewCell : UITableViewCell
@property (nonatomic,strong)AdminModel *adminModel;
@property (weak, nonatomic) IBOutlet UILabel *title_lbl;
@property (weak, nonatomic) IBOutlet UILabel *name_lbl;
@property (weak, nonatomic) IBOutlet UILabel *tel_lbl;
@property (weak, nonatomic) IBOutlet UILabel *company_lbl;
@property (weak, nonatomic) IBOutlet UILabel *start_lbl;
@property (weak, nonatomic) IBOutlet UILabel *end_lbl;

@property (weak, nonatomic) IBOutlet UILabel *reason_lbl;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;
@property (weak, nonatomic) IBOutlet UIView *dilivi_view;

@property (weak, nonatomic) IBOutlet UIImageView *markImage;


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomDivid_view;

@property (weak, nonatomic) IBOutlet UIButton *sendPawordBtn;
@property (weak,nonatomic) id<adminAuthouSendPawordDelegate>delegate;

@property(nonatomic,assign)float cellHeight;
@end
