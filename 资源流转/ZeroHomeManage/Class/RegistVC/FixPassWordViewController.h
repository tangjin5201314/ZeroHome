//
//  FixPassWordViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//


#import "BaseViewController.h"

@interface FixPassWordViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *oldPassWord;

@property (weak, nonatomic) IBOutlet UITextField *npassWord;
@property (weak, nonatomic) IBOutlet UITextField *npassWordagain;
@property (weak, nonatomic) IBOutlet UIImageView *Check;
@property (weak, nonatomic) IBOutlet UIButton *Done;
@property (weak, nonatomic) IBOutlet UIImageView *oldPassWordright;
@property (weak, nonatomic) IBOutlet UIImageView *passwordRight;
@property (weak, nonatomic) IBOutlet UILabel *oldpasswordlabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordlabel;

@end
