//
//  homePageBtn.m
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "homePageBtn.h"
#import "UIViewExt.h"

@implementation homePageBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)titleRectForContentRect:(CGRect)contentRect{
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT_SYSTEM(18)}];
    CGSize imageSize = [[self imageForState:UIControlStateNormal] size];
    return CGRectMake((self.width-titleSize.width-imageSize.width)/2, 4, titleSize.width, titleSize.height);
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:FONT_SYSTEM(18)}];
    CGSize imageSize = [[self imageForState:UIControlStateNormal] size];
    
//    CGFloat x = (contentRect.size.width - imageSize.width ) / 2;
    CGFloat y = 12;
    return CGRectMake((self.width-titleSize.width-imageSize.width)/2+titleSize.width+3, y, imageSize.width, imageSize.height);
}
@end
