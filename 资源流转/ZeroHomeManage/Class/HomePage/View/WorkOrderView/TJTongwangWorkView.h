//
//  TJTongwangWorkView.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/6/6.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "convenceBtn.h"

@protocol TJTongwangWorkViewDelegat <NSObject>
- (void)selectTongwangWorkBtnTag:(NSInteger)tag;

@end

@interface TJTongwangWorkView : UIView
@property (nonatomic,strong)convenceBtn *btn;
@property (nonatomic,weak)id<TJTongwangWorkViewDelegat>delegate;
@end
