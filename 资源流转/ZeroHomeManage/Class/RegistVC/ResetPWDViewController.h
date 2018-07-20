//
//  ResetPWDViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface ResetPWDViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *resetPassWord;
@property (weak, nonatomic) IBOutlet UITextField *againPassWord;

@property (nonatomic,strong)NSString *verification;
@property (nonatomic,strong)NSString *phoneNum;
@end
