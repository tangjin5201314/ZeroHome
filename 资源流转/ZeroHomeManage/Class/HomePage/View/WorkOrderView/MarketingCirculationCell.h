//
//  MarketingCirculationCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^callBackSelectMessage)(NSInteger messageInt);

@interface MarketingCirculationCell : UITableViewCell
@property (nonatomic,copy)callBackSelectMessage block;
@end
