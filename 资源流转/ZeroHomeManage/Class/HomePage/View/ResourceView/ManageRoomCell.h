//
//  ManageRoomCell.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "convenceBtn.h"
@protocol selectManageButtonDelegat <NSObject>

- (void)selectManageBtnTag:(NSInteger)tag;

@end
@interface ManageRoomCell : UIView
@property (nonatomic,strong)convenceBtn *btn;
@property(nonatomic,weak)id<selectManageButtonDelegat>delegate;
@end
