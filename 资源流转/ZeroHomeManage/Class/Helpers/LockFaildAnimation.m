//
//  LockFaildAnimation.m
//  ZeroHome
//
//  Created by TW on 16/12/20.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "LockFaildAnimation.h"
#import "UIViewExt.h"

@implementation LockFaildAnimation
{
    UIView *backView;
}
static LockFaildAnimation *lockFaild;

+(instancetype)shardLockFaildHud
{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
    lockFaild = [[LockFaildAnimation alloc]init];
    });

    return lockFaild;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        
        backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 274, 230)];
        backView.backgroundColor = [UIColor clearColor];
        backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)*0.4);
        [backView.layer setMasksToBounds:YES];
        [backView.layer setCornerRadius:5.0];
//        backView.layer.shouldRasterize = YES;
        [self addSubview:backView];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 274, 208)];
        imageview.center = CGPointMake(backView.width*0.5, backView.height*0.5);
        NSMutableArray *images = [[NSMutableArray alloc]init];
        for(int i=1;i<8;i++){
            [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"过程动效%dxhdpi",i]]];
        }
        imageview.animationImages = images;
        imageview.animationDuration = 1.0f;
        imageview.animationRepeatCount = 0;
        [imageview startAnimating];
        [backView addSubview:imageview];
    }
    return self;
}


+(void)addSuccessAnimation
{
    [[self shardLockFaildHud]successAnimation];
}

- (void)successAnimation
{
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 274, 208)];
    imageview.center = CGPointMake(backView.width*0.5, backView.height*0.5);
    imageview.image = [UIImage imageNamed:@"失败动效9xhdpi"];
    [backView addSubview:imageview];

}

+(void)dismiss
{
    
}


@end
