//
//  customAreaViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//


#import "BaseViewController.h"

@interface customAreaViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *wuye;
@property (weak, nonatomic) IBOutlet UITextField *Area;
@property (weak, nonatomic) IBOutlet UIView *cityView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

@property (weak, nonatomic) IBOutlet UITextField *address;
@property (weak, nonatomic) IBOutlet UIButton *done;

@property(nonatomic,strong)NSString *iPhoneNumber;

@property(nonatomic,assign)BOOL isEdit;
//是否是完善资料
@property(nonatomic,assign)BOOL isPerfectData;

@end
