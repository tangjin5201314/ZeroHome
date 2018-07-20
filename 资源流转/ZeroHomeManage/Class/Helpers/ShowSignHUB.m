//
//  ShowSignHUB.m
//  ZeroHome
//
//  Created by TW on 16/4/12.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "ShowSignHUB.h"
#import "NSString+category.h"
#import "AppDelegate.h"

#define TJKeyWindow  [UIApplication sharedApplication].keyWindow
@implementation ShowSignHUB


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (ShowSignHUB*)showSharedView {
    static dispatch_once_t once;
    
    static ShowSignHUB *sharedView;
#if !defined(SV_APP_EXTENSIONS)
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds]; });
#else
    dispatch_once(&once, ^{ sharedView = [[self alloc] initWithFrame:[[UIScreen mainScreen] bounds]]; });
#endif
    return sharedView;
}


+(void)showSignInfo:(NSString *)message;
{
   
    [[self showSharedView]showStatus:message ];
    
}

- (void)showStatus:(NSString*)status
{
    //@property (nonatomic,strong)ShowSignHUB *view;
    ShowSignHUB *view = [[ShowSignHUB alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
    view.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)*0.7);
    
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.6;
    
    view.layer.masksToBounds = YES;
    
    view.layer.cornerRadius = 8.0f;
    view.layer.shouldRasterize = YES;
    [TJKeyWindow addSubview:view];
    
   UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.bounds.size.width, 80)];
    
    lable.numberOfLines = 3;
    
    lable.text = status;
    
    lable.textColor = [UIColor whiteColor];
    
    lable.textAlignment = NSTextAlignmentCenter;

    [view addSubview:lable];

    
    [UIView animateWithDuration:1 animations:^{
        view.transform = CGAffineTransformMakeTranslation(0, -150);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        
    }];
    
   
}


@end
