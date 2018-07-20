//
//  LoginViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "LoginViewController.h"
#import "QuickRegViewController.h"
#import "ResetPassWordViewController.h"
#import "registeredViewController.h"
#import "NSString+category.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "AFNetworking.h"
#import "DataUtility.h"
#import "UIUtility.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "YDGHUB.h"
#import "UpYun.h"
#import "SelectAreaViewController.h"
#import "TabBarMainViewController.h"
#import "WorkOrderHomeController.h"
#import "AuthentifiModel.h"
#import "MJExtension.h"

@interface LoginViewController ()
@property(nonatomic,strong)NSString *iPhonenumber;
@property(nonatomic,strong)NSString *verification_Str;
@property(nonatomic,strong)NSString *imageURL;
@end

@implementation LoginViewController{
    NSMutableData *_data;
    
    YDGHUB *hub;
    NSString *gender;
}

/*
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(![QQApiInterface isQQInstalled]){
        _qqLogin.hidden = YES;
    }else{
        _qqLogin.hidden = NO;
    }
    if(![WXApi isWXAppInstalled]){
        _weixinLogin.hidden = YES;
    }else{
        _weixinLogin.hidden = NO;
        
    }
    if(_qqLogin.hidden&&_weixinLogin.hidden){
        _leftview.hidden= YES;
        _rightVIew.hidden = YES;
        _otherLabel.hidden = YES;
    }else{
        _leftview.hidden= NO;
        _rightVIew.hidden = NO;
        _otherLabel.hidden = NO;
    }
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hub = [YDGHUB shardYDGHUB];

    //记住密码
    _userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"USERNAME"];
    _PassWord.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"PASSWORD"];
    
    [_remenberbtn setImage:[UIImage imageNamed:@"复选框_sellected"] forState:UIControlStateSelected];
    _remenberbtn.selected = YES;
    
    [self CreatUI];

}
#pragma UI
-(void)CreatUI{
    self.navigationController.navigationBarHidden = YES;
    
    if(SCREEN_WIDTH<375){
        _logoImage.bounds = CGRectMake(0, 0, 94, 84);
    }
    
    _qqLogin.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqClick)];
    [_qqLogin addGestureRecognizer:tgr1];
    _weixinLogin.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinClick)];
    [_weixinLogin addGestureRecognizer:tgr2];
    
}
#pragma mark - All Click

- (IBAction)nowRegist:(id)sender {
    registeredViewController *vc = [[registeredViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 快速注册
- (IBAction)quickReg:(id)sender {
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"Reg"};
    [MobClick event:@"app_register" attributes:dict];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    registeredViewController *reg = [[registeredViewController alloc]initWithNibName:@"registeredViewController" bundle:nil];
    [self.navigationController pushViewController:reg animated:YES];
}

#pragma mark - 快捷登陆
- (IBAction)quickLogin:(id)sender {    
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"app_quicLogin"};
    [MobClick event:@"app_quicLogin" attributes:dict];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    QuickRegViewController *quickReg = [[QuickRegViewController alloc]initWithNibName:@"QuickRegViewController" bundle:nil];
    [self.navigationController pushViewController:quickReg animated:YES];
}

#pragma mark - 登录
- (IBAction)Login:(id)sender {
     BOOL isValid = [DataUtility isPhoneNumberValid:self.userName.text];
       if (isValid && self.PassWord.text != nil && ![self.PassWord.text isEqualToString:@""]) {
        //统计登陆按钮点击次数
        NSDictionary *dict = @{@"type" : @"login"};
        [MobClick event:@"app_login" attributes:dict];
        
        [self loginMethodWithParams];
        
    }else{
        if ([_userName.text isEqualToString:@""]) {
           [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入电话号码"];
        }else {
        if (!isValid) {
            
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"电话号码格式有误"];
            
        }else{
            
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入密码"];
        }
        }
    }

}

#pragma mark - 查询用户是什么权限  1、通网  6、管理员  其他
- (void)requestQueryCheckUserState
{
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];

    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryCheckUser];
    
    NSDictionary *parameters = @{@"token":usertoken};
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"查询用户是否为认证用户==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSDictionary *dic = jsonObj[@"message"][@"constructionUserVO"];
            AuthentifiModel *model = [AuthentifiModel mj_objectWithKeyValues:dic];
            
            areaType = model.type;
            realName = model.realName;
            if (areaType == 6 || areaType == 9) {
                TabBarMainViewController *tabVC = [[TabBarMainViewController alloc]init];
                app.window.rootViewController = tabVC;
                
            }else{
                WorkOrderHomeController *vc = [[WorkOrderHomeController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                app.window.rootViewController = nav;
            }

        }else{
            [SVProgressHUD showInfoWithStatus:@"未录入系统，请联系管理员"];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


-(void)loginMethodWithParams{
    //开始登陆加等待图
 //   [self.view addSubview:self.hub];

    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSString *channelID = app.channelId;
    if(channelID == nil){
        channelID = @"";
    }
    //版本号
     NSString *vesion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    vesion = [NSString stringWithFormat:@"i-%@",vesion];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kLogin];
    NSString *password = [_PassWord.text stringFromMD5];
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setObject:_userName.text forKey:@"tel"];
    [parameters setObject:password forKey:@"pwd"];
    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"coreVersion"];
    [parameters setObject:vesion forKey:@"version"];
    [parameters setObject:channelID forKey:@"channelId"];
    [parameters setObject:@4 forKey:@"belong"];
    NSLog(@"登录=%@",parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"登录:%@",jsonObj);
        
        NSString *result = [jsonObj objectForKey:@"success"];
        if([result boolValue]){
            //记住密码
            if(_remenberbtn.selected){
                [[NSUserDefaults standardUserDefaults] setObject:_userName.text forKey:@"USERNAME"];
                [[NSUserDefaults standardUserDefaults] setObject:_PassWord.text forKey:@"PASSWORD"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"USERNAME"];
                [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"PASSWORD"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *token = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
            [ud setObject:token forKey:@"token"];
            usertoken = token;
            NSString *phoneNum =  _userName.text;
            [ud setObject:phoneNum forKey:@"iphoneNumber"];
            phoneNumber = phoneNum;
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            self.user.isLogin = YES;
            self.user.iphoneNumber = _userName.text;
            self.user.loginPassWord = _PassWord.text;
            NSDictionary *message = [jsonObj objectForKey:@"message"];
            NSDictionary *release = [message objectForKey:@"release"];
            NSDictionary *newRelease = [message objectForKey:@"newRelease"];
            [self.user setrelease:release];
            [self.user setnewrelease:newRelease];
            self.user.token = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
            [self requestQueryCheckUserState];
           
            //登陆成功开始统计
            [MobClick profileSignInWithPUID:@"playerID"];
            
            
            [_userName resignFirstResponder];
            [_PassWord resignFirstResponder];
            
        }else{

            [SVProgressHUD showErrorWithStatus:[jsonObj objectForKey:@"reason"]];
        }
        
        //完成移除等待图
        //[self.hub removeFromSuperview];
        
    } Error:^(NSString *errMsg, id jsonObj) {
        NSLog(@"登陆失败");
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        //完成移除等待图
        //[self.hub removeFromSuperview];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
    
}

#pragma mark - 忘记密码
- (IBAction)forgetPassWord:(id)sender {
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"app_forgetPassword"};
    [MobClick event:@"app_forgetPassword" attributes:dict];
    
    ResetPassWordViewController *quickReg = [[ResetPassWordViewController alloc]initWithNibName:@"ResetPassWordViewController" bundle:nil];
    [self.navigationController pushViewController:quickReg animated:YES];
}


#pragma mark - 第三方qq登录
-(void)qqClick{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        NSLog(@"%d",response.responseCode);
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self LoginToQQ:snsAccount];
            
            
        }});
    //获取accestoken以及QQ用户信息，得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        
        NSDictionary *infoDic = response.data;
        gender = infoDic[@"gender"];
    }];
}
-(void)LoginToQQ:(UMSocialAccountEntity *)snsAccount{
    self.user.openId = snsAccount.openId;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kThirdLogin];
    //版本号
    NSString *vesion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    vesion = [NSString stringWithFormat:@"i-%@",vesion];
    NSDictionary *parametes = [[NSDictionary alloc]initWithObjectsAndKeys:
                               snsAccount.openId,@"openId",
                               snsAccount.iconURL,@"headPortrait",
                               snsAccount.userName,@"nickname",
                               gender,@"sex",
                               vesion,@"version",
                               nil];
    NSLog(@"第三方paramets:%@",parametes);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"%@",jsonObj);
        self.user.isLogin = YES;
        self.user.isThirdLogin = YES;
        NSDictionary *message = [jsonObj objectForKey:@"message"];
        NSDictionary *release = [message objectForKey:@"release"];
        NSDictionary *newRelease = [message objectForKey:@"newRelease"];
        [self.user setrelease:release];
        [self.user setnewrelease:newRelease];
        usertoken = [[jsonObj objectForKey:@"message"] objectForKey:@"token"];
        if([[[jsonObj objectForKey:@"message"] objectForKey:@"register"] isEqualToString:@"false"]){
            self.user.isPerfect = NO;
        }else{
            self.user.isPerfect = YES;
        }
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];

          TabBarMainViewController *tabVC = [[TabBarMainViewController alloc]init];
        delegate.window.rootViewController = tabVC;
                //自定义统计登录
        [MobClick profileSignInWithPUID:@"playerID" provider:@"OtherLogin"];
        
        

        
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parametes IsSava:NO delegate:self isRefresh:NO];

    
}

#pragma mark - 第三方微信登录
-(void)weixinClick{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ ,url is %@,%@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL,UMSCustomAccountGenderMale);
            [self LoginToQQ:snsAccount];
        }
        
    });
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
        NSDictionary *infoDic = response.data;
        gender = infoDic[@"gender"];
    }];
}

#pragma mark - 记住密码
- (IBAction)remenber:(id)sender {
    _remenberbtn.selected = !_remenberbtn.selected;
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
