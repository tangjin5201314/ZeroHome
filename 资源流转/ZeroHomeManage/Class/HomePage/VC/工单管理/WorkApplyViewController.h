//
//  WorkApplyViewController.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/10.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface WorkApplyViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet UIView *phto_view;
@property (weak, nonatomic) IBOutlet UIView *mtorRoom_view;
@property (weak, nonatomic) IBOutlet UIView *authenTime_view;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *diliviView;
@end
