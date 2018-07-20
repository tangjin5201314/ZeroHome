//
//  UIView+Frame.m
//  ZeroHome
//
//  Created by TW on 17/9/18.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setXmg_height:(CGFloat)xmg_height
{
    CGRect rect = self.frame;
    rect.size.height = xmg_height;
    self.frame = rect;
}

- (void)setXmg_width:(CGFloat)xmg_width
{
    CGRect rect = self.frame;
    rect.size.width = xmg_width;
    self.frame = rect;
}

- (void)setXmg_x:(CGFloat)xmg_x
{
    CGRect rect = self.frame;
    rect.origin.x = xmg_x;
    self.frame = rect;
}

- (void)setXmg_y:(CGFloat)xmg_y
{
    CGRect rect = self.frame;
    rect.origin.y = xmg_y;
    self.frame = rect;
}

- (void)setXmg_centerX:(CGFloat)xmg_centerX
{
    CGPoint center = self.center;
    center.x = xmg_centerX;
    self.center = center;
}

- (void)setXmg_centerY:(CGFloat)xmg_centerY
{
    CGPoint center = self.center;
    center.y = xmg_centerY;
    self.center = center;
}

- (CGFloat)xmg_height
{
    return self.frame.size.height;
}

- (CGFloat)xmg_width
{
    return self.frame.size.width;
}

- (CGFloat)xmg_centerX
{
    return self.center.x;
}

- (CGFloat)xmg_centerY
{
    return self.center.y;
}

- (CGFloat)xmg_x
{
    return self.frame.origin.x;
    
}

- (CGFloat)xmg_y
{
    
    return self.frame.origin.y;
}

@end
