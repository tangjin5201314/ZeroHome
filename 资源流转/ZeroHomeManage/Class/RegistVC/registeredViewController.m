//
//  registeredViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "registeredViewController.h"
#import "DataUtility.h"
#import "UIUtility.h"
#import "SelectAreaViewController.h"
#import "UMSocial.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "YDGHUB.h"
#import "PersonSetViewController.h"
#import "smallAreaModel.h"
#import "HomePageViewController.h"

@interface registeredViewController ()<userdelegate>
@property (nonatomic,strong)NSMutableArray *areaDataArray;
@end

@implementation registeredViewController
{
    YDGHUB *hub;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if(![QQApiInterface isQQInstalled]){
//        _qq_image.hidden = YES;
//    }else{
//        _qq_image.hidden = NO;
//    }
//    if(![WXApi isWXAppInstalled]){
//        _weixin_image.hidden = YES;
//    }else{
//        _weixin_image.hidden = NO;
//    }
//    if(_qq_image.hidden&&_weixin_image.hidden){
//        _leftView.hidden= YES;
//        _rightView.hidden = YES;
//        _other_lbl.hidden = YES;
//    }else{
//        _leftView.hidden= NO;
//        _rightView.hidden = NO;
//        _other_lbl.hidden = NO;
//    }
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.GetCheck.titleLabel.adjustsFontSizeToFitWidth= YES;
    _areaDataArray = [[NSMutableArray alloc]initWithCapacity:0];
     hub = [YDGHUB shardYDGHUB];

    if(SCREEN_WIDTH<375){
        _logoImage.bounds = CGRectMake(0, 0, 94, 84);
    }
    
    self.user.delegate = self;
    if(self.user.timeReg<60&&self.user.timeReg>0){
        _GetCheck.enabled = NO;
    }
    [self CreateUI];
//    if(_isPerfectData){
//        _titleLabel.text = @"手机验证";
//    }
    
//    [self loadData]; //查询小区
}
-(void)CreateUI{
    _qq_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(qqClick)];
    [_qq_image addGestureRecognizer:tgr1];
    _weixin_image.userInteractionEnabled = YES;
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(weixinClick)];
    [_weixin_image addGestureRecognizer:tgr2];
}

#pragma mark - 获取验证码
- (IBAction)Getyanzhengma:(id)sender {
    BOOL isValid = [DataUtility isPhoneNumberValid:self.iPhoneNumber.text];
    if(isValid){
        NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kSendSms];
        NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                    self.iPhoneNumber.text,@"tel",
                                    nil];
        [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
            NSLog(@"获取验证码:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"] intValue]){
                _GetCheck.enabled = NO;
                self.user.timeReg = 60;
                [self.user StartTimeFixpassword];
                

                _iPhonenumber = _iPhoneNumber.text;
                _checknumber = [[jsonObj objectForKey:@"message"] objectForKey:@"verification"];;
                [SVProgressHUD showSuccessWithStatus:@"验证码已发送成功"];
            }else{
                
            }
        } Error:^(NSString *errMsg, id jsonObj) {
            ;
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];

    }else{
        if ([_iPhoneNumber.text isEqualToString:@""]) {
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入手机号码"];
        }else{
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"手机号码格式有误!"];
        }

    }
}

#pragma mark -- 查询小区----
-(void)loadData{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kQueryArea];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                [NSNumber numberWithInt:1],@"pageNum",
                                [NSNumber numberWithInt:10],@"pageSize",
                                nil];
    NSLog(@"%@",parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        if([[jsonObj objectForKey:@"success"] boolValue]){
            NSDictionary *message = [jsonObj objectForKey:@"message"];
            NSDictionary *communityPage = [message objectForKey:@"communityPage"];
            NSDictionary *list = [communityPage objectForKey:@"list"];
            for (NSDictionary *dict in list) {
                smallAreaModel *model = [[smallAreaModel alloc]initWith:dict];
                [_areaDataArray addObject:model];
            }
            
        }

    } Error:^(NSString *errMsg, id jsonObj) {

    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}



#pragma mark - User delegate
-(void)IntervaltimeFixpassword{
    if(self.user.timeReg==0){
        _GetCheck.enabled = YES;
        [_GetCheck setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        _GetCheck.titleLabel.text = [NSString stringWithFormat:@"获取验证码"];
    }else{
        _GetCheck.titleLabel.text = [NSString stringWithFormat:@"%ld秒后再次发送",(long)self.user.timeReg];
        [_GetCheck setTitle:[NSString stringWithFormat:@"%ld秒后再次发送",(long)self.user.timeReg] forState:UIControlStateNormal];
    }
}


#pragma mark - 注册
- (IBAction)registBtn:(id)sender {
    [self.view endEditing:YES];
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"Reg"};
    [MobClick event:@"app_register" attributes:dict];
    
    BOOL isValid = [DataUtility isPhoneNumberValid:self.iPhoneNumber.text];
    
    if (isValid && self.verification_filed.text != nil && ![self.verification_filed.text isEqualToString:@""]&&[self.verification_filed.text isEqualToString:_checknumber]) {
        if ([self.iPhoneNumber.text isEqualToString:phoneNumber]) {
            [SVProgressHUD showErrorWithStatus:@"号码已被注册"];
        }else{
           PersonSetViewController *personSet = [[PersonSetViewController alloc]initWithNibName:@"PersonSetViewController" bundle:nil];
            personSet.iPhoneNumber =  _iPhoneNumber.text;
            personSet.tenement = @"";
            personSet.address = @"";
            personSet.isPerfectData = _isPerfectData;
            [self.navigationController pushViewController:personSet animated:YES];
        }
        
    }else{
        if ([_iPhoneNumber.text isEqualToString:@""]) {
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入手机号码"];
        }else{
            if (!isValid) {
                [UIUtility showAlertViewWithTitle:@"提示" messsge:@"电话号码格式有误"];
            }else{
                if ([_verification_filed.text isEqualToString:@""]) {
                  [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入验证码"];
                }else{
                  [UIUtility showAlertViewWithTitle:@"提示" messsge:@"验证码错误"];
                }
            }
        }
    }

    
}



#pragma mark - 退出登录
- (IBAction)quitLogin:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.user.timerFix invalidate];
}

#pragma mark - 退到首页
//- (IBAction)quitToRoot:(id)sender {
//    [self.http stop];
//    [self.user.timerFix invalidate];
//
//    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    //    self.mainVC= (MainViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"MainViewController"];
//    self.mainVC= (MainViewController *)[mainStoryBoard instantiateViewControllerWithIdentifier:@"propertyViewController"];
//
//    //统计按钮点击次数
//    NSDictionary *dict = @{@"type" : @"skip"};
//    [MobClick event:@"app_skip" attributes:dict];
//    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
//    app.window.rootViewController = self.mainVC;
//
//}

#pragma mark - 第三方登录

-(void)qqClick{
    [self.view addSubview:hub];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [hub removeFromSuperview];
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
        
        
        
    }];
}
-(void)LoginToQQ:(UMSocialAccountEntity *)snsAccount{
    self.user.openId = snsAccount.openId;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kThirdLogin];
    NSDictionary *parametes = [[NSDictionary alloc]initWithObjectsAndKeys:
                               snsAccount.openId,@"openId",
                               snsAccount.iconURL,@"headPortrait",
                               snsAccount.userName,@"nickname",
                               //snsAccount.userName,@"sex",
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
        HomePageViewController *vc = [[HomePageViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        
        //自定义统计登录
        [MobClick profileSignInWithPUID:@"playerID" provider:@"OtherLogin"];
        
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.window.rootViewController = nav;
        
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parametes IsSava:NO delegate:self isRefresh:NO];
}

#pragma mark - 第三方微信登录
-(void)weixinClick{
    [self.view addSubview:hub];
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        [hub removeFromSuperview];
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self LoginToQQ:snsAccount];
        }
        
    });
    //得到的数据在回调Block对象形参respone的data属性
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
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
