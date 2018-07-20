//
//  convenceBtn.m
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "convenceBtn.h"

@implementation convenceBtn

-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:11.0f]];
    CGSize imageSize = [[self imageForState:UIControlStateNormal] size];
    
    CGFloat x = (contentRect.size.width - titleSize.width) / 2;
    //imageSize.height/2 + (contentRect.size.height - titleSize.height)/2+8
    CGFloat y = (contentRect.size.height+imageSize.height-titleSize.height)/2+5;
    
    return CGRectMake(x, y, contentRect.size.width, titleSize.height);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize titleSize = [title sizeWithFont:[UIFont systemFontOfSize:13.0f]];
    CGSize imageSize = [[self imageForState:UIControlStateNormal] size];
    
    CGFloat x = (contentRect.size.width - imageSize.width ) / 2;
    CGFloat y = (contentRect.size.height-(imageSize.height+titleSize.height+10))/2;
    
    return CGRectMake(x, y, imageSize.width, imageSize.height);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
