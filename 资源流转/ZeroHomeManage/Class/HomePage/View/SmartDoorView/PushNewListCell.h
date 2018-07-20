//
//  PushNewListCell.h
//  ZeroHome
//
//  Created by TW on 16/12/19.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewPushModel.h"
@interface PushNewListCell : UITableViewCell
@property (nonatomic,strong)NewPushModel *pushModel;
@property (weak, nonatomic) IBOutlet UILabel *first_lbl;
@property (weak, nonatomic) IBOutlet UILabel *second_lbl;
@property (weak, nonatomic) IBOutlet UILabel *thrd_lbl;
@end
