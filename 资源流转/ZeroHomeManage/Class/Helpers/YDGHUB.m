//
//  YDGHUB.m
//  ZeroHome
//
//  Created by 汤锦 on 16/9/17.
//  Copyright (c) 2016年 TW. All rights reserved.
//

#import "YDGHUB.h"
#import "UIViewExt.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@implementation YDGHUB

static YDGHUB *ydghub;
+(instancetype)shardYDGHUB{
    if(ydghub==nil){
        ydghub = [[YDGHUB alloc]init];
    }
    return ydghub;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 72, 72)];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.5f];
        backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)*0.4);
        [backView.layer setMasksToBounds:YES];
        [backView.layer setCornerRadius:5.0];
        [self addSubview:backView];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 21)];
        imageview.center = CGPointMake(backView.width*0.5, backView.height*0.4);
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for(int i=0;i<4;i++){
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d",i]]];
        }
        imageview.animationImages = images;
        imageview.animationDuration = .9f;
        imageview.animationRepeatCount = 0;
        [imageview startAnimating];
        [backView addSubview:imageview];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, imageview.bottom+2, backView.width, backView.height-imageview.bottom-4)];
        label.font = [UIFont systemFontOfSize:10];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"努力加载中...";
        label.textColor = [UIColor whiteColor];
        [backView addSubview:label];

    }
    return self;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
