//
//  ResetPWDViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "ResetPWDViewController.h"
#import "DataUtility.h"
#import "UIUtility.h"
#import "NSString+category.h"
@interface ResetPWDViewController ()
@property (nonatomic,strong)UIView *shadoView;
@property (nonatomic,strong)UIView *backView;
@end

@implementation ResetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickDone:(id)sender {
    if ([_resetPassWord.text isEqualToString:@""]) {
    [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入重置密码"];
    }else if ([_againPassWord.text isEqualToString:@""]){
    [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请再次输入"];
    }else if (![_resetPassWord.text isEqualToString:_againPassWord.text]){
    [UIUtility showAlertViewWithTitle:@"提示" messsge:@"两次输入密码不一致"];
    }else{
        NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kFixPassWord];
        NSString *passWord = [self.resetPassWord.text stringFromMD5];
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    _phoneNum,@"tel",
                                    passWord,@"newPwd",
                                    _verification,@"verification",
                                    nil];
        [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
            NSLog(@"修改密码:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"] intValue]){
                [self showUpdatePassWordSuccess];
                
                [[NSUserDefaults standardUserDefaults] setObject:self.resetPassWord.text forKey:@"PASSWORD"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                [SVProgressHUD showErrorWithStatus:[jsonObj objectForKey:@"reason"]];
            }
        } Error:^(NSString *errMsg, id jsonObj) {
            ;
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
  
    }
  
}


- (IBAction)back_btn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showUpdatePassWordSuccess
{
    _shadoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _shadoView.backgroundColor = [UIColor blackColor];
    _shadoView.alpha = 0.3;
    [self.view addSubview:_shadoView];
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 80, 160)];
    _backView.backgroundColor = [UIColor whiteColor];
    _backView.layer.cornerRadius = 5;
    _backView.clipsToBounds = YES;
    _backView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)*0.5);
    [self.view addSubview:_backView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(_backView.width/2 - 20, 20, 40, 40)];
    imageView.image = [UIImage imageNamed:@"勾"];
    [_backView addSubview:imageView];
    
    UILabel *message_lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, imageView.bottom+13, _backView.width, 30)];
    message_lbl.textAlignment = NSTextAlignmentCenter;
    message_lbl.text = @"密码重置成功";
    message_lbl.font = FONT_SYSTEM(14);
    message_lbl.textColor = COLOR_RGB(117, 117, 117);
    [_backView addSubview:message_lbl];
    
    UIView *separeView = [[UIView alloc]initWithFrame:CGRectMake(0, message_lbl.bottom+10, _backView.width, 0.5)];
    separeView.backgroundColor = [UIColor lightGrayColor];
    [_backView addSubview:separeView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, message_lbl.bottom+15, _backView.width, 35);
    [btn setTitle:@"回到登录页" forState:UIControlStateNormal];
    [btn setTitleColor:COLOR_RGB(79, 172, 246) forState:UIControlStateNormal];
    btn.font = FONT_SYSTEM(18);
    [btn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:btn];
}

- (void)clickBack:(UIButton *)btn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_shadoView removeFromSuperview];
    _shadoView = nil;
    _backView = nil;
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_backView removeFromSuperview];
}

- (void)removeMessage
{
    [_shadoView removeFromSuperview];
    _shadoView = nil;
    _backView = nil;
    [_backView removeFromSuperview];
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
