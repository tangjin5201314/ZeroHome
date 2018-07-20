//
//  CustomWorkOrderView.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/8.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "convenceBtn.h"

@protocol CustomWorkOrderManageDelegat <NSObject>
- (void)selectWorkOrderManegeBtnTag:(NSInteger)tag;

@end

@interface CustomWorkOrderView : UIView
@property (nonatomic,strong)convenceBtn *btn;
@property (nonatomic,weak)id<CustomWorkOrderManageDelegat>delegate;
@end
