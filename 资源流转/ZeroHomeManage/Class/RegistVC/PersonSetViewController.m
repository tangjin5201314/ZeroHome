//
//  PersonSetViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "PersonSetViewController.h"
#import "UIUtility.h"
#import "NSString+category.h"
#import "DelegateViewController.h"
#import "DataUtility.h"
#import "HomePageViewController.h"

@interface PersonSetViewController ()

@end

@implementation PersonSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"用户注册";
    
    // Do any additional setup after loading the view from its nib.
    [_man setImage:[UIImage imageNamed:@"UnSex"] forState:UIControlStateNormal];
    [_wuman setImage:[UIImage imageNamed:@"UnSex"] forState:UIControlStateNormal];
    [_man setImage:[UIImage imageNamed:@"Sex"] forState:UIControlStateSelected];
    [_wuman setImage:[UIImage imageNamed:@"Sex"] forState:UIControlStateSelected];
    _man.selected = YES;
    _wuman.selected = NO;
    [_yuedu setImage:[UIImage imageNamed:@"Undelegate"] forState:UIControlStateNormal];
    [_yuedu setImage:[UIImage imageNamed:@"delegate"] forState:UIControlStateSelected];
    _yuedu.selected = YES;
    
    _Area.text = _AreaName;
    _Area.enabled = NO;
    
    [_Done.layer setMasksToBounds:YES];
    [_Done.layer setCornerRadius:5.0];
}


- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)man:(id)sender {
    _man.selected = YES;
    _wuman.selected = NO;
}
- (IBAction)wuman:(id)sender {
    _wuman.selected = YES;
    _man.selected = NO;
}
- (IBAction)yuedu:(id)sender {
    _yuedu.selected = !_yuedu.selected;
}

- (IBAction)mydelegate:(id)sender {
    DelegateViewController *service = [[DelegateViewController alloc]initWithNibName:@"DelegateViewController" bundle:nil];
    [self.navigationController pushViewController:service animated:YES];
}
- (IBAction)done:(id)sender {
    if(_Email.text.length == 0){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"邮箱不能为空!"];
    }else if (![DataUtility isValidateEmail:_Email.text]){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"邮箱格式不正确!"];
    }else if(_passWord.text.length <6||_passWord.text.length>12){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入6-12位密码!"];
    }else if (_NickName&&_NickName.text.length==0){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"昵称不能为空!"];
    }else if (!_yuedu.selected){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"您尚未同意零点家园服务条款!"];
    }else{
        if(_isPerfectData){
            [self PerfectData];
        }else{
            [self Registered];
        }
    }
}
//注册
-(void)Registered{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kRegister];
    NSLog(@"%@",URLStr);
    
    NSString *passWord = [_passWord.text stringFromMD5];
    
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                _iPhoneNumber,@"phoneNumber",
                                passWord,@"password",
                                _NickName.text,@"nickname",
                                [NSNumber numberWithInt:_branchId],@"branchId",
                                _Email.text,@"email",
                                [NSNumber numberWithInt:_man.selected?0:1],@"sex",
                                @"",@"branchName",
                                @"",@"tenement",
                                @"",@"address",
                                nil];
    NSLog(@"%@",parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"注册成功:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            usertoken = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
            
            self.user.isLogin = YES;
            self.user.loginPassWord = _passWord.text;
            [[NSUserDefaults standardUserDefaults] setObject:_iPhoneNumber forKey:@"USERNAME"];
            [[NSUserDefaults standardUserDefaults] setObject:_passWord.text forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults] setObject:_iPhoneNumber forKey:@"iphoneNumber"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            HomePageViewController *vc = [[HomePageViewController alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
            
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            delegate.window.rootViewController = nav;
            
            [SVProgressHUD showSuccessWithStatus:@"注册成功"];
        }
        else{
        [SVProgressHUD showErrorWithStatus:[jsonObj objectForKey:@"reason"]];
    }
     
    } Error:^(NSString *errMsg, id jsonObj) {
        NSLog(@"登陆失败");
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
//完善
-(void)PerfectData{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kPerfectData];
    NSLog(@"%@",URLStr);
    
    NSString *passWord = [_passWord.text stringFromMD5];
    
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                _iPhoneNumber,@"phoneNumber",
                                passWord,@"password",
                                _NickName.text,@"nickname",
                                [NSNumber numberWithInt:_branchId],@"branchId",
                                _Email.text,@"email",
                                [NSNumber numberWithInt:_man.selected?0:1],@"sex",
                                _AreaName,@"branchName",
                                _tenement,@"tenement",
                                _address,@"address",
                                usertoken,@"token",
                                self.user.openId,@"openId",
                                nil];
    NSLog(@"%@",parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"注册成功:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            usertoken = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
            self.user.isPerfect = YES;
//            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"完善资料成功"];
            [SVProgressHUD showSuccessWithStatus:@"完善资料成功"];

            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[jsonObj objectForKey:@"reason"]];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if(textField==_Email&&_Email.text.length == 0){
//        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"邮箱不能为空!"];
//    }else if(textField==_passWord&&(_passWord.text.length <6||_passWord.text.length>12)){
//        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入6-12位密码!"];
//    }else if (textField==_NickName&&_NickName.text.length==0){
//        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"昵称不能为空!"];
//    }
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
