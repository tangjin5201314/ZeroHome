//
//  TJCover.m
//  ZeroHome
//
//  Created by TW on 17/9/7.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import "TJCover.h"

@implementation TJCover

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(void)show
{
    TJCover *cover = [[TJCover alloc]initWithFrame:[UIScreen mainScreen].bounds];
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.6;
    
    // 把蒙版对象添加主窗口
    [TJKeyWindow addSubview:cover];
}


+ (void)hide
{
    for (UIView *childView in TJKeyWindow.subviews) {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}

@end
