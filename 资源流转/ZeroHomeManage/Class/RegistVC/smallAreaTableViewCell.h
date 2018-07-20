//
//  smallAreaTableViewCell.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "smallAreaModel.h"

@interface smallAreaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *AreaName;
@property (weak, nonatomic) IBOutlet UILabel *adress;

@property(nonatomic,strong)smallAreaModel *SmallAreaModel;
@end
