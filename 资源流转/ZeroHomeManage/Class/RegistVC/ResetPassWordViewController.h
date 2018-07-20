//
//  ResetPassWordViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface ResetPassWordViewController : BaseViewController<UITextFieldDelegate,userdelegate>{
    NSTimer *timer;
    int seconds;
}
@property (weak, nonatomic) IBOutlet UIButton *Queding;
@property (weak, nonatomic) IBOutlet UITextField *iphoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *CheckSms;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UITextField *PassWordAgain;
@property (weak, nonatomic) IBOutlet UIButton *Getyanzhengma;

//标示是否是完善资料
@property(nonatomic,assign)BOOL isPerfectData;
@end
