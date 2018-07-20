//
//  registeredViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface registeredViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *iPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *GetCheck;
@property (weak, nonatomic) IBOutlet UITextField *verification_filed;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UIImageView *qq_image;
@property (weak, nonatomic) IBOutlet UIImageView *weixin_image;

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UILabel *other_lbl;

@property(nonatomic,strong)NSString *iPhonenumber; //手机号码
@property(nonatomic,strong)NSString *checknumber; //验证码
//标示是否是完善资料
@property(nonatomic,assign)BOOL isPerfectData;
@end
