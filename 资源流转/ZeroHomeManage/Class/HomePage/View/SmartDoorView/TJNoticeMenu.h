//
//  TJNoticeMenu.h
//  ZeroHome
//
//  Created by TW on 17/9/9.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TJNoticeMenu;
@protocol TJActiveMenuDelegate <NSObject>

- (void)activeMenuDidClickCloseBtn:(TJNoticeMenu *)menu;

@end
@interface TJNoticeMenu : UIView

@property (nonatomic,weak)id<TJActiveMenuDelegate>delegate;


+ (instancetype)showInpoint:(CGPoint)point;
+ (void)hide;
@end
