//
//  SelectItemCollectionViewCell.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoomPortModel.h"

@interface SelectItemCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *operatorName_lbl;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong)RoomPortModel *model;
@end
