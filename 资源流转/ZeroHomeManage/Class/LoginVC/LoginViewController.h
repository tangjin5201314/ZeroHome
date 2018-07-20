//
//  LoginViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<NSURLConnectionDataDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *ForgetPassWord;
@property (weak, nonatomic) IBOutlet UIButton *quickReg;
@property (weak, nonatomic) IBOutlet UIButton *quicklog;
@property (weak, nonatomic) IBOutlet UIImageView *qqLogin;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *PassWord;
@property (weak, nonatomic) IBOutlet UIButton *remenberbtn;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (weak, nonatomic) IBOutlet UIImageView *weixinLogin;
@property (weak, nonatomic) IBOutlet UIView *leftview;
@property (weak, nonatomic) IBOutlet UIView *rightVIew;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;

@end
