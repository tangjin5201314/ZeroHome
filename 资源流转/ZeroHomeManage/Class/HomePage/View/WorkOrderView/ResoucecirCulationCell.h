//
//  ResoucecirCulationCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ResoucecirCulationCellDelegate <NSObject>

- (void)clickSelectUserBtn:(UIButton *)btn;

@end
@interface ResoucecirCulationCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *jieru_field;
@property (weak, nonatomic) IBOutlet UIButton *yingxiaoNameBtn;
@property (nonatomic,weak)id<ResoucecirCulationCellDelegate>delegate;
@end
