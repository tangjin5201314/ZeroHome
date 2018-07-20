//
//  TJNoticeMenu.m
//  ZeroHome
//
//  Created by TW on 17/9/9.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import "TJNoticeMenu.h"

@implementation TJNoticeMenu


- (IBAction)closeBtn:(UIButton *)sender {
    if (_delegate&&[_delegate respondsToSelector:@selector(activeMenuDidClickCloseBtn:)]) {
        [_delegate activeMenuDidClickCloseBtn:self];
    }
    
}


#pragma mark - 显示菜单
+ (instancetype)showInpoint:(CGPoint)point
{
    TJNoticeMenu *notice = [TJNoticeMenu noticeMenu];
    notice.center = point;
    [TJKeyWindow addSubview:notice];
    
    return notice;
}

#pragma mark - 隐藏菜单

+ (void)hide
{
    for(TJNoticeMenu *childView in TJKeyWindow.subviews)
    {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}



+(instancetype)noticeMenu
{
    return [[NSBundle mainBundle]loadNibNamed:@"TJNoticeMenu" owner:nil options:nil][0];
}



@end
