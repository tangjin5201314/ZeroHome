//
//  PageLockCell.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/10.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol lockRoowBtnDelegate <NSObject>
- (void)keyLockBtn;
@end

@interface PageLockCell : UITableViewCell
@property (nonatomic,weak)id<lockRoowBtnDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIButton *pageLockBtn;

@end
