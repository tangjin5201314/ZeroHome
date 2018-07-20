//
//  MessageListCell.h
//  ZeroHome
//
//  Created by TW on 16/11/30.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenLockModel.h"


typedef enum {
    kCellTypeLockRecord,
    kCellTypePushNews,
}CellType;

@interface MessageListCell : UITableViewCell
@property (nonatomic,strong)OpenLockModel *lockModel;
@property (nonatomic, readwrite)CellType cellType;

@property (weak, nonatomic) IBOutlet UILabel *first_lbl;
@property (weak, nonatomic) IBOutlet UILabel *second_lbl;
@property (weak, nonatomic) IBOutlet UILabel *thrd_lbl;
@property (weak, nonatomic) IBOutlet UILabel *usePhone_lbl;

@end
