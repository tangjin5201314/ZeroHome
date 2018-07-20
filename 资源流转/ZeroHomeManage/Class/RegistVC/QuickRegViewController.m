//
//  QuickRegViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "QuickRegViewController.h"
#import "registeredViewController.h"
#import "UIUtility.h"
#import "NSString+category.h"
#import "DataUtility.h"
#import "SelectAreaViewController.h"
#import "DataUtility.h"
#import "HomePageViewController.h"
@interface QuickRegViewController ()<userdelegate>

@end

@implementation QuickRegViewController{
    BOOL text2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    self.user.delegate = self;
    _GetCheck.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if(self.user.timeQui<60&&self.user.timeQui>0){
        _GetCheck.enabled = NO;
    }
    text2 = NO;
    [self CreatUI];
}
-(void)textFieldChanged{
    if([_CheckSms isEditing]){
        if([self.user.QuiLoginCheck isEqualToString:_CheckSms.text]){
            _Why.image = [UIImage imageNamed:@"Duigou"];
            text2 = YES;
        }else{
            _Why.image = [UIImage imageNamed:@"why"];
            text2 = NO;
        }
    }
}
-(void)CreatUI{
    [_login.layer setMasksToBounds:YES];
    [_login.layer setCornerRadius:5.0];
}
- (IBAction)Back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)Login:(id)sender {
    if(![DataUtility isPhoneNumberValid:_iPhoneNumber.text]){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"电话号码格式不正确!"];
    }else if (text2){
        [self regAndLogin];
    }else{
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"验证码不正确"];
    }
    
}
-(void)regAndLogin{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSString *channelID = app.channelId;
    if(channelID == nil){
        channelID = @"0";
    }
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kQuiLogin];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                self.iPhoneNumber.text,@"tel",
                                _CheckSms.text,@"verification",
                                channelID,@"channelId",
                                nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"验证并登陆:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            HomePageViewController *vc = [[HomePageViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            [self presentViewController:nav animated:YES completion:^{
                usertoken = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
                self.user.isLogin = YES;
            }];

        }else{
            SelectAreaViewController *selectAreaVC = [[SelectAreaViewController alloc]initWithNibName:@"SelectAreaViewController" bundle:nil];
            selectAreaVC.iPhoneNumber = _iPhoneNumber.text;
            [self.navigationController pushViewController:selectAreaVC animated:YES];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
- (IBAction)quickReg:(id)sender {
    registeredViewController *reg = [[registeredViewController alloc]initWithNibName:@"registeredViewController" bundle:nil];
    [self.navigationController pushViewController:reg animated:YES];
}
- (IBAction)Getyanzhengma:(id)sender {
    BOOL isValid = [DataUtility isPhoneNumberValid:self.iPhoneNumber.text];
    if(isValid){
        NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kSendSms];
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    self.iPhoneNumber.text,@"tel",
                                    //self.user.token,@"token",
                                    [NSNumber numberWithInt:2],@"type",
                                    nil];
        NSLog(@"%@",parameters);
        [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
            NSLog(@"获取验证码:%@",jsonObj);
            if([jsonObj objectForKey:@"success"]){
                _GetCheck.enabled = NO;
                self.user.timeQui = 60;
                [self.user StartTimeFixpassword];
                self.user.QuiLoginCheck = [[jsonObj objectForKey:@"message"] objectForKey:@"verification"];
            }
        } Error:^(NSString *errMsg, id jsonObj) {
            ;
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
    }else{
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入正确的手机号"];
    }
}
-(void)IntervaltimeFixpassword{
    if(self.user.timeQui==0){
        _GetCheck.enabled = YES;
        [_GetCheck setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _GetCheck.titleLabel.text = [NSString stringWithFormat:@"获取验证码"];
    }else{
        _GetCheck.titleLabel.text = [NSString stringWithFormat:@"%ld秒后再次发送",self.user.timeQui];
        [_GetCheck setTitle:[NSString stringWithFormat:@"%ld秒后再次发送",self.user.timeQui] forState:UIControlStateNormal];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
