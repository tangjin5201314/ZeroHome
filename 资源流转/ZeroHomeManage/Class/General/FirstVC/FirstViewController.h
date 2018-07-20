//
//  FirstViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 16/8/26.
//  Copyright (c) 2016年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView *mainScrollView;

@property(nonatomic,assign)BOOL isSetPush;
@end
