//
//  TJsendPwBtn.m
//  ZeroHome
//
//  Created by TW on 17/9/18.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import "TJsendPwBtn.h"
#import "UIView+Frame.h"

@implementation TJsendPwBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //设置文字的位置
    self.titleLabel.xmg_x = 0;
    self.titleLabel.centerY = self.xmg_height*0.5;
    
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    
    //设置图片的位置
    self.imageView.xmg_x = self.titleLabel.xmg_width+7;
    self.imageView.centerY = self.xmg_height*0.5;
    
}

@end
