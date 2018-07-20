//
//  QuickRegViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface QuickRegViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UIButton *quickReg;
@property (weak, nonatomic) IBOutlet UIImageView *Why;
@property (weak, nonatomic) IBOutlet UIButton *GetCheck;
@property (weak, nonatomic) IBOutlet UITextField *iPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *CheckSms;

@end
