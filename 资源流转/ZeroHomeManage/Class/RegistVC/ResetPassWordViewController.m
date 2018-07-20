//
//  ResetPassWordViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "ResetPassWordViewController.h"
#import "DataUtility.h"
#import "UIUtility.h"
#import "NSString+category.h"
#import "ResetPWDViewController.h"
#import "SelectAreaViewController.h"

@interface ResetPassWordViewController ()
@property (nonatomic,strong)NSString *verification_str;
@end

@implementation ResetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.user.isThirdLogin){
    self.title_lbl.text = @"新人注册";
    }
    // Do any additional setup after loading the view from its nib.

    self.user.delegate = self;
    [self CreatUI];
}
-(void)CreatUI{

    _Getyanzhengma.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    if(self.user.timeFix<60&&self.user.timerFix>0){
        _Getyanzhengma.enabled = NO;
    }
}


- (IBAction)nextBtn:(id)sender {
    [self.view endEditing:YES];
    BOOL isValid = [DataUtility isPhoneNumberValid:self.iphoneNumber.text];
    
    if (isValid &&self.CheckSms.text.length>0) {
        
        if([self.CheckSms.text isEqualToString:self.user.FixCheck]){
            [self nextDone];
        }else{
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"验证码有误"];
        }
        
    }else{
        if ([_iphoneNumber.text isEqualToString:@""]) {
         [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入电话号码"];
        }else{
            if (!isValid) {
                
                [UIUtility showAlertViewWithTitle:@"提示" messsge:@"电话号码格式有误"];
                
            }else{
                [UIUtility showAlertViewWithTitle:@"提示" messsge:@"验证码不能为空"];
            }

        }
    }
}




- (void)nextDone
{
    if(self.user.isThirdLogin){
            SelectAreaViewController *vc = [[SelectAreaViewController alloc]init];
            vc.iPhoneNumber = _iphoneNumber.text;
            vc.isPerfectData = _isPerfectData;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
    }else{
        ResetPWDViewController *vc = [[ResetPWDViewController alloc]init];
        vc.phoneNum = _iphoneNumber.text;
        vc.verification = self.CheckSms.text;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
    
}

-(void)done{

    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kFixPassWord];
    NSString *passWord = [self.PassWord.text stringFromMD5];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                self.iphoneNumber.text,@"tel",
                                passWord,@"newPwd",
                                self.CheckSms.text,@"verification",
                                nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"修改密码:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] intValue]){
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"修改密码成功!"];
            [[NSUserDefaults standardUserDefaults] setObject:self.PassWord.text forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [SVProgressHUD showErrorWithStatus:[jsonObj objectForKey:@"reason"]];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
- (IBAction)Getyanzhengma:(id)sender {
    BOOL isValid = [DataUtility isPhoneNumberValid:self.iphoneNumber.text];
    if ([_iphoneNumber.text isEqualToString:@""]) {
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入电话号码"];
    }else{
        if(!isValid){
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"电话号码格式有误"];
        }else{
            NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kSendSms];
            NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                        self.iphoneNumber.text,@"tel",
                                        [NSNumber numberWithInt:0],@"type",
                                        nil];
            [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
                NSLog(@"获取验证码:%@",jsonObj);
                _Getyanzhengma.enabled = NO;
                self.user.timeFix = 60;
                [self.user StartTimeFixpassword];
                self.user.FixCheck = [[jsonObj objectForKey:@"message"] objectForKey:@"verification"];
                _verification_str = [[jsonObj objectForKey:@"message"] objectForKey:@"verification"];
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送成功"];
                
            } Error:^(NSString *errMsg, id jsonObj) {
                ;
            } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
        }
    }
  
}
-(void)IntervaltimeFixpassword{
    if(self.user.timeFix==0){
        _Getyanzhengma.enabled = YES;
        [_Getyanzhengma setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _Getyanzhengma.titleLabel.text = [NSString stringWithFormat:@"获取验证码"];
    }else{
    _Getyanzhengma.titleLabel.text = [NSString stringWithFormat:@"%ld秒后再次发送",self.user.timeFix];
    [_Getyanzhengma setTitle:[NSString stringWithFormat:@"%ld秒后再次发送",self.user.timeFix] forState:UIControlStateNormal];
    }
}
- (IBAction)back:(UIButton *)sender {
    if(timer){
        [timer invalidate];
    }
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
