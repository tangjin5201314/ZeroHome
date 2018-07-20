//
//  HomePageViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "HomePageViewController.h"
#import "UMSocialSnsService.h"
#import "UMSocialData.h"
#import "UMSocialConfig.h"
#import "UMSocialControllerService.h"
#import "UMSocialSnsPlatformManager.h"
#import "UIUtility.h"
#import "convenceBtn.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "CustButtonForCell.h"
#import "signinModel.h"
#import "NSString+category.h"
#import "SDCycleScrollView.h"
#import "AuthentifiModel.h"
#import "SmartUnlockController.h"
#import "AppDelegate.h"
#import "YDGHUB.h"
#import "HomepageRoowCell.h"
#import "CustPickerView.h"
#import "MotoRoomModel.h"
#import "DataUtility.h"
#import "PageLockCell.h"
#import "CapacityUnlockController.h"
#import "MessageRecordViewController.h"
#import "LockFaildAnimation.h"
#import  <GJSDK/GoplusManager.h>
#import "TJCover.h"
#import "TJNoticeMenu.h"
#import "LockRecordViewController.h"
#import "MotoRoomTimeViewController.h"
#import "AdminViewController.h"
#import "MyCenterViewController.h"
#import "ResourceHomeController.h"
#import "LoginViewController.h"
#import "IQKeyboardManager.h"

typedef NS_ENUM(NSInteger, NYTAdRequestState) {
    NYTAdRequestStateSuccess,
    NYTAdRequestStateNetErrors,
    NYTAdRequestStateOtherErrors,
    NYTAdRequestStateTimeErrors,
    NYTAdRequestStateUnAuthorsErrors,
    NYTAdRequestStateFaild
};

static  NSString *HomePageRoow = @"HomepageRoowCell";
static  NSString *HomePageLockCell = @"PageLockCell";
@interface HomePageViewController ()<selectButtonDelegat,SDCycleScrollViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,lockRoowBtnDelegate,TJActiveMenuDelegate>
//@property (nonatomic,strong)convenceBtn *btn;
@property (nonatomic,strong)NSMutableArray *mifiImageArra;
@property(nonatomic, weak) UITextField *motoRoom_Field;
@property (nonatomic,weak) UIImageView *arrow_image;
@property (nonatomic,weak) UIButton *sumit_Btn;
@end

@implementation HomePageViewController{
    MJRefreshFooterView *footView;
    MJRefreshHeaderView *headerView;
    NSArray *images;
    NSArray *titles;
    NSArray *subtitles;
    NSMutableArray *tableArrayData;
    int pageNum;
    signinModel *signModel;
    SDCycleScrollView *cycleScrollView;
    YDGHUB *hub;
    AuthentifiModel *_model;
     NSArray *imgArray;  //图片数组
    
    NSMutableArray *roomLockNo_arry;  //机房编号数组
    NSMutableArray *roomName_arry;    //机房名称
    NSMutableArray *roomID_arry;      //机房ID数组
    NSNumber *numId;                  //机房id
    NSString *lock_noStr;             //机房编号
    LockFaildAnimation *faildHud; //失败动画效果
    NSString *phoneNum;
    UIView *backView;        //开锁成功动画背景
    NSString *auth_code; //授权码
    __block NSInteger faildCount;  //记录开锁失败次数
    
//    NSInteger areaType;  //用户类型  通网，管理员
    
    NSInteger saveAreaType;    //记录当前的type是多少

}


#pragma mark - 设置导航栏控件
- (void)initNavBar
{
    //导航栏标题
    _titleBtn = [[homePageBtn alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
    [_titleBtn setTitle:@"机房智能门禁系统" forState:UIControlStateNormal];

    [_titleBtn setTitleColor:COLOR_RGB(79, 172, 246) forState:UIControlStateNormal];
    
    self.navigationItem.titleView = _titleBtn;
    
//    [self setRightButtonWithTitle:@"资源管理" action:@selector(rightManegeBtn:)];

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [cycleScrollView adjustWhenControllerViewWillAppera];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    hub = [YDGHUB shardYDGHUB];
    faildHud = [LockFaildAnimation shardLockFaildHud];
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    tableArrayData  = [[NSMutableArray alloc]initWithCapacity:0];
    _mifiImageArra = [[NSMutableArray alloc]initWithCapacity:0];
    roomName_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomID_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomLockNo_arry = [[NSMutableArray alloc]initWithCapacity:0];
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    phoneNum = [ud objectForKey:@"iphoneNumber"];
    pageNum = 1;

    [self initNavBar];
    [self topview];
    
    
}

- (void)setFooterView
{
    
}


#pragma mark - 获取申请过权限的机房
- (void)requestQueryRoomByUser
{
    [roomName_arry removeAllObjects];
    [roomLockNo_arry removeAllObjects];
    [roomID_arry removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryRoomByUser];
    
    NSDictionary *parameters = @{@"token":usertoken,@"tel":phoneNum};
    NSLog(@"yyyyyy==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取申请过权限的机房==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSArray *lockRoomArray = jsonObj[@"message"][@"LockRoomVOs"];
            for(NSDictionary *dic in lockRoomArray)
            {
                MotoRoomModel *model = [MotoRoomModel mj_objectWithKeyValues:dic];
                
                NSString *roomName = model.room_name;
                [roomName_arry addObject:roomName];
                
                [roomID_arry addObject:[NSNumber numberWithInteger:model.ID]];
                
                [roomLockNo_arry addObject:model.lock_no];
                /*保存机房信息,便于推送时获取数据*/
                NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
                [pushJudge setObject:roomName_arry forKey:@"roomName"];
                [pushJudge setObject:roomID_arry forKey:@"roomId"];
                [pushJudge setObject:roomLockNo_arry forKey:@"roomLock"];
                [pushJudge synchronize];
            }
            if (roomName_arry.count>0) {
                if (![DataUtility isBlankObject:_roomName]) {
                    _motoRoom_Field.text = _roomName;
                    [self requestSaveCheckUserWithLock:_roomLock_no];//获取机房授权码
                }else{
                    _motoRoom_Field.text = roomName_arry[0];
                    numId = roomID_arry[0];
                    lock_noStr = roomLockNo_arry[0];
                    [self requestSaveCheckUserWithLock:lock_noStr];//获取机房授权码
                }
            }
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark - 获取开锁授权码
- (void)requestSaveCheckUserWithLock:(NSString *)lockNo
{
    [self.maintableView addSubview:hub];
    NSDictionary *parameters;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,@"/lock/authCode"];
    if (realName == nil) {
        realName = @"";
    }
    parameters = @{@"token":usertoken,@"lock_no":lockNo,@"pwd_user_mobile":phoneNum,@"pwd_user_name":realName};
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取开锁授权码==:%@",jsonObj);
        if ([[jsonObj objectForKey:@"success"]boolValue]) {
            auth_code = jsonObj[@"message"][@"result"][@"data"] [@"auth_code"];
            _sumit_Btn.enabled = YES;
        }
        else{
//            [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
            _sumit_Btn.enabled = NO;
        }
        
       [hub removeFromSuperview];
    } Error:^(NSString *errMsg, id jsonObj) {
        [hub removeFromSuperview];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark - 查询用户是什么权限  1、通网  6、管理员  其他
- (void)requestQueryCheckUserState
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryCheckUser];
    
    NSDictionary *parameters = @{@"token":usertoken};
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        [hub removeFromSuperview];
        NSLog(@"查询用户是否为认证用户==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSDictionary *dic = jsonObj[@"message"][@"constructionUserVO"];
            _model = [AuthentifiModel mj_objectWithKeyValues:dic];
                saveAreaType = _model.type;
                areaType = _model.type;
            realName = _model.realName;
        }else{
            _sumit_Btn.enabled = NO;
            [SVProgressHUD showInfoWithStatus:@"未录入系统，请联系管理员"];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            delegate.window.rootViewController = nav;
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [hub removeFromSuperview];
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark - 获取开锁授权码并开锁
- (void)requestUnLockSaveCheckUserWithLock:(NSString *)lockNo
{
    NSDictionary *parameters;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,@"/lock/authCode"];
    if (realName == nil) {
        realName = @"";
    }
    parameters = @{@"token":usertoken,@"lock_no":lockNo,@"pwd_user_mobile":phoneNum,@"pwd_user_name":realName};
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取开锁授权码==:%@",jsonObj);
        if ([[jsonObj objectForKey:@"success"]boolValue]) {
            auth_code = jsonObj[@"message"][@"result"][@"data"] [@"auth_code"];
            [self openLockWithAuthCode:auth_code];
        }
        else{
            
            _sumit_Btn.enabled = NO;
        }
        
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark - topView
-(void)topview{
   cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 161) delegate:self placeholderImage:[UIImage imageNamed:@"金沙花园135.jpg"]];
    cycleScrollView.pageControlBottomOffset = 10;
    cycleScrollView.currentPageDotColor = HexRGB(0x4facf6);
    cycleScrollView.pageDotColor = HexRGB(0xc2c2c2);
   
    
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStylePlain];
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    _maintableView.tableHeaderView = cycleScrollView;
    _maintableView.tableFooterView = [UIView new];
    _maintableView.backgroundColor = COLOR_RGB(237, 237, 240);
    [self.view addSubview:_maintableView];
    
    UINib *nib = [UINib nibWithNibName:HomePageRoow bundle:nil];
    [_maintableView registerNib:nib forCellReuseIdentifier:HomePageRoow];
    
    UINib *nib1 = [UINib nibWithNibName:HomePageLockCell bundle:nil];
    [_maintableView registerNib:nib1 forCellReuseIdentifier:HomePageLockCell];
    
    if (!usertoken) {
        
    }else{

        cycleScrollView.imageURLStringsGroup = @[@"智能门锁Banner"];
        [self requestQueryCheckUserState]; //查询用户是什么类型  通网、管理员
        [self requestQueryRoomByUser]; //获取申请过权限的机房
        
    }
   
}


#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
        return 1;
     
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomepageRoowCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageRoow];
        _motoRoom_Field = cell.homepage_tefild;
        _arrow_image = cell.arrowImage;
        _motoRoom_Field.delegate = self;
        [cell.refreshBtn addTarget:self action:@selector(clickOutCheckRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
//            if (![DataUtility isBlankObject:_pushDic]) {
//                _motoRoom_Field.text = _pushDic[@"room_name"];
//            }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        CustButtonForCell *custBtnView = [[CustButtonForCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100*2+1)];
        custBtnView.delegate = self;
        
        [cell.contentView addSubview:custBtnView];
        
        
        return cell;
        
    }else{
        PageLockCell *cell = [tableView dequeueReusableCellWithIdentifier:HomePageLockCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        _sumit_Btn = cell.pageLockBtn;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 54;
    }else if(indexPath.section == 1){
         return 92*2+1.5;
    }else{
        return 60;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    headView.backgroundColor = COLOR_RGB(237, 237, 240);
   
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 5, SCREEN_WIDTH, 21)];
    title_lbl.font = [UIFont systemFontOfSize:14];
    title_lbl.textColor = COLOR_RGB(102, 102, 102);
    if (section == 0) {
      title_lbl.text = @"选择门禁";
    }else if(section == 1){
     title_lbl.text = @"相关操作";
    }else{
       title_lbl.text = @"开锁";
    }
    

    [headView addSubview:title_lbl];
    return headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}


#pragma mark - custButtonDelegate
#pragma mark  --一键开锁----
- (void)keyLockBtn
{
    if (![DataUtility isBlankObject:_roomName])
    {
        [self noticeToothBlueStateWithLock:_roomLock_no];
        
    }else{
        
        [self noticeToothBlueStateWithLock:lock_noStr];
    }
}


//管理员
- (void)selectBtnTag:(NSInteger)tag
{
    switch (tag) {
        case 2000:
            if (!usertoken) {
                [SVProgressHUD showInfoWithStatus:@"您未登录"];
            }else{
                [self ApplyForAuthorization]; //申请授权
            }
            break;
        case 2001:
             [self authorizationRecode]; //授权记录
            break;
        case 2002:
            if (!usertoken) {
                [SVProgressHUD showInfoWithStatus:@"您未登录"];
            }else{
                [self lockRecode]; //开锁记录
            }
            break;
        case 2003:
        {
            if (!usertoken) {
                [SVProgressHUD showInfoWithStatus:@"您未登录"];
            }else{
                 [self messagePush]; //门禁状态
            }
        }
            break;
        case 2004:
        {
            if (!usertoken) {
                [SVProgressHUD showInfoWithStatus:@"您未登录"];
            }else{
                if (areaType == 6) {
                   [self authorizationManage]; //授权管理
                }else{
                    [SVProgressHUD showInfoWithStatus:@"您暂无权限授权"];
                }
               
            }
        }
            break;
        case 2005:
        {
            
            if (!usertoken) {
                [SVProgressHUD showInfoWithStatus:@"您未登录"];
            }else{
                
                [self personalCenter]; //个人中心
            }
            
        }
            break;
        
        default:
            break;
    }
}

//申请授权
- (void)ApplyForAuthorization
{
    if (![DataUtility isBlankObject:lock_noStr])
    {
        CapacityUnlockController *vc = [[CapacityUnlockController alloc]init];
        if (areaType == 6) {
            vc.peopleInfomation = NSKAdmin;
        }else if (areaType == 1)
        {
            vc.peopleInfomation = NSKTongWang;
        }else{
            vc.peopleInfomation = NSKYunying;
        }
        vc.callBackLockBlock = ^(NSString *CapaCityroomName, NSString *CapaCityroomLock_no, NSNumber *CapaCityroomId) {
            self.roomName = CapaCityroomName;
            self.roomLock_no = CapaCityroomLock_no;
            self.roomId = CapaCityroomId;
        } ;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [SVProgressHUD showInfoWithStatus:@"请联系管理员绑定机房"];
        return;
    }
    
}

//授权记录
- (void)authorizationRecode
{
    MotoRoomTimeViewController *vc = [[MotoRoomTimeViewController alloc]init];
    if (![DataUtility isBlankObject:_roomName]){
        vc.motoRoomName = _roomName;
        vc.roomId = _roomId;
    }else{
        if (![DataUtility isBlankObject:numId])
        {
            vc.motoRoomName = _motoRoom_Field.text;
            vc.roomId = numId;
        }else{
            [SVProgressHUD showInfoWithStatus:@"请联系管理员绑定机房"];
            return;
        }
        
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//开锁记录
- (void)lockRecode
{
        LockRecordViewController *vc = [[LockRecordViewController alloc]init];
        if (![DataUtility isBlankObject:_roomName]){
            vc.lock_no = _roomLock_no;
        }else{
            if (![DataUtility isBlankObject:lock_noStr])
            {
                vc.lock_no = lock_noStr;
            }else{
                [SVProgressHUD showInfoWithStatus:@"请联系管理员绑定机房"];
                return;
            }
            
        }
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

}

//授权管理
-(void)authorizationManage
{
    AdminViewController *vc = [[AdminViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//个人中心
- (void)personalCenter
{
    MyCenterViewController *vc = [[MyCenterViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//门禁状态
- (void)messagePush
{
    MessageRecordViewController *vc = [[MessageRecordViewController alloc]init];
    if (![DataUtility isBlankObject:_roomName]) {
        vc.lock_no = _roomLock_no;
    }else{
        if (![DataUtility isBlankObject:lock_noStr])
        {
            vc.lock_no = lock_noStr;
        }else{
            [SVProgressHUD showInfoWithStatus:@"请联系管理员绑定机房"];
            return;
        }
        
    }
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)noticeToothBlueStateWithLock:(NSString *)lockNo
{
    if ([toothBlueState isEqualToString:@"PoweredOff"]) {
        UIAlertController *alertController    = [UIAlertController alertControllerWithTitle:@"提示" message:IOSCoreToothBLueNotic preferredStyle:UIAlertControllerStyleAlert];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:true completion:nil];
        
    }else if([toothBlueState isEqualToString:@"PoweredOn"]){
//        _sumit_Btn.enabled = NO;
        [self requestUnLockSaveCheckUserWithLock:lockNo];
    }
}

- (void)openLockWithAuthCode:(NSString *)code
{
    /*
    [self addAnimationFaildLock];
    [[GoplusManager sharedManager] openLock:code callBackHandle:^(NSString *callBackCode) {
        NSLog(@"callBackCode==%@",callBackCode);
        
        if ([callBackCode isEqualToString:@"HH0000"]) {
            faildCount = 0;
            _sumit_Btn.enabled = YES; //按钮可点击
            [self delayTimeMethod];
            [self requestLockAuthCodeWithReason:@"开锁成功" type:@"Y" withTag:@"1" ];
            [self addSuccessAnimationWithState:NYTAdRequestStateSuccess];
        }else{
            if (faildCount >=2) {//如果连续开门失败三次以上，发送密码
                [self delayTimeMethod];
                _sumit_Btn.enabled = YES; //按钮可点击
                [self requestLockAuthCodeWithReason:@"开锁失败" type:@"N" withTag:@"2" ];
                //弹出蒙版
                [TJCover show];
                
                //弹出活动菜单
                TJNoticeMenu *menu = [TJNoticeMenu showInpoint:self.view.center];
                menu.delegate = self;
                faildCount = 0;
                return ;
            }
            faildCount ++;
            if ([callBackCode isEqualToString:@"HH9999"]){
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"其他错误" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateOtherErrors];
            }else if ([callBackCode isEqualToString:@"NET00001"]) {
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"网络未连接" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateNetErrors];
            }else if ([callBackCode isEqualToString:@"NET00002"]){
                
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"网络连接异常" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateNetErrors];
            }else if ([callBackCode isEqualToString:@"OPS00001"]){
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self addSuccessAnimationWithState:NYTAdRequestStateOtherErrors];
                [self requestLockAuthCodeWithReason:@"数据格式无法解析" type:@"N" withTag:@"1"];
            }else if ([callBackCode isEqualToString:@"OPS02102"]){
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"服务器端门锁信息不存在" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateUnAuthorsErrors];
            }else if ([callBackCode isEqualToString:@"OPS07102"]){
                
                _sumit_Btn.enabled = NO; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"授权信息不存在" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateUnAuthorsErrors];
            }
            else if ([callBackCode isEqualToString:@"BLE00001"]) {
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"无法找到指定门锁" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateUnAuthorsErrors];
            }else if ([callBackCode isEqualToString:@"BLE00002"]){
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"连接失败,门锁无响应" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateFaild];
            }else if ([callBackCode isEqualToString:@"BLE00003"]){
                
                [self delayTimeMethod];
                [self addSuccessAnimationWithState:NYTAdRequestStateFaild];
                [self requestLockAuthCodeWithReason:@"连接失败,需要重新初始化" type:@"N" withTag:@"1"];
            }else if ([callBackCode isEqualToString:@"BLE00004"]){
                
                [self delayTimeMethod];
                [self addSuccessAnimationWithState:NYTAdRequestStateFaild];
                [self requestLockAuthCodeWithReason:@"连接失败,无法获取状态" type:@"N" withTag:@"1"];
            }else if ([callBackCode isEqualToString:@"BLE00005"]){
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [self requestLockAuthCodeWithReason:@"连接失败,设置通知失败" type:@"N" withTag:@"1"];
                [self addSuccessAnimationWithState:NYTAdRequestStateFaild];
            }else if ([callBackCode isEqualToString:@"BLE00006"]){
                
                _sumit_Btn.enabled = YES; //按钮可点击
                [self delayTimeMethod];
                [SVProgressHUD showInfoWithStatus:@"蓝牙设备未开启"];
            }else if ([callBackCode isEqualToString:@"BLE00007"]){
                
                [self requestLockAuthCodeWithReason:@"开锁指令时效有误" type:@"N" withTag:@"1"];
                [self delayTimeMethod];
                [self addSuccessAnimationWithState:NYTAdRequestStateTimeErrors];
            }
            
        }
    }];
     */
}


#pragma mark - -------textFieldDelegate------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _roomName = nil;
    [_motoRoom_Field resignFirstResponder];
    _arrow_image.image = [UIImage imageNamed:@"上拉"];
    if (roomName_arry.count>0) {
        CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:roomName_arry];
        [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger num) {
            _motoRoom_Field.text = selectedDate;
            _arrow_image.image = [UIImage imageNamed:@"下拉"];

            numId = [roomID_arry objectAtIndex:num];
            lock_noStr = [roomLockNo_arry objectAtIndex:num];

        }];
    }
}

#pragma mark ---刷新门禁列表--------
- (void)clickOutCheckRoomBtn:(UIButton *)btn
{
    
//    [_dataArray removeAllObjects];
//    [_maintableView addSubview:hub];
//    roomTimeCount = 1;
//    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
//    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
//        NSString *lockNo = _pushDic[@"lock_no"];
//        NSNumber *roomId = _pushDic[@"roomId"];
//        [self requestSaveCheckUserWithLock:lockNo];//获取授权码
//        return;
//    }
    
    if (![DataUtility isBlankObject:_roomName])
    {
        [self requestSaveCheckUserWithLock:_roomLock_no];
//        [self requestQueryUserbyTelWithRoomId:_roomId];
    }else{
//        [self requestQueryUserbyTelWithRoomId:numId];//获取授权时限
        if (![DataUtility isBlankObject:lock_noStr]){
             [self requestSaveCheckUserWithLock:lock_noStr];//获取授权码
        }else{
            [SVProgressHUD showInfoWithStatus:@"请联系管理员绑定机房"];
        }
        
    }
    
}


- (void)addAnimationFaildLock
{
    [_maintableView addSubview:faildHud];
    
}

- (void)delayTimeMethod
{
    [faildHud removeFromSuperview];
}

#pragma mark - 开锁失败反馈
- (void)requestLockAuthCodeWithReason:(NSString *)reason type:(NSString *)type withTag:(NSString *)tag
{
    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KLockFaildNotification];
    if (realName == nil) {
        realName = @"";
    }
    
    NSString *lockNo;
    
    if (![DataUtility isBlankObject:_roomName]) {
        lockNo = _roomLock_no;
    }else{
        NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
        if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
//            lockNo = _pushDic[@"lock_no"];
        }else{
            lockNo = lock_noStr;
        }
        
    }
    //手机机型
    NSString *platform = [DataUtility iphoneType];
    NSString* Version = [[UIDevice currentDevice] systemVersion];
    NSString *platformVersion = [platform stringByAppendingString:Version];
    
    NSDictionary *parameters = @{@"lock_no":lockNo,@"token":usertoken,@"op_way":@"0",@"user_name":realName,@"user_mobile":phoneNum,@"type":type,@"reason":reason,@"timeApp":startTime,@"mobileType":platformVersion,@"sysType":[NSNumber numberWithInt:2],@"tag":tag};
    NSLog(@"开锁失败dic==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"开锁失败==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


- (void)addSuccessAnimationWithState:(NYTAdRequestState)state
{
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 274, 230)];
    backView.backgroundColor = [UIColor clearColor];
    backView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT*0.4+44);
    [backView.layer setMasksToBounds:YES];
    [backView.layer setCornerRadius:5.0];
    //    backView.layer.shouldRasterize = YES;
    [_maintableView addSubview:backView];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 274, 208)];
    imageview.center = CGPointMake(274*0.5, 230*0.5);
    [backView addSubview:imageview];
    if (state == NYTAdRequestStateSuccess) {
        imageview.image = [UIImage imageNamed:@"失败动效9xhdpi"];
    }else if (state == NYTAdRequestStateNetErrors)
    {
        imageview.image = [UIImage imageNamed:@"失败动效1xhdpi"];
    }else if (state == NYTAdRequestStateOtherErrors)
    {
        imageview.image = [UIImage imageNamed:@"失败动效2xhdpi"];
    }else if (state == NYTAdRequestStateTimeErrors)
    {
        imageview.image = [UIImage imageNamed:@"失败动效3xhdpi"];
    }else if (state == NYTAdRequestStateUnAuthorsErrors)
    {
        imageview.image = [UIImage imageNamed:@"失败动效4xhdpi"];
    }else if (state == NYTAdRequestStateFaild)
    {
        imageview.image = [UIImage imageNamed:@"失败动效5xhdpi"];
    }
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1/*延迟执行时间*/ * NSEC_PER_SEC));
    __weak typeof (self)weakSelf = self;
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [weakSelf successImageremove];
        
    }) ;
}

- (void)successImageremove
{
    [backView removeFromSuperview];
}

#pragma mark ------点击按钮关闭弹出框
- (void)activeMenuDidClickCloseBtn:(TJNoticeMenu *)menu
{
    [TJCover hide];
    [TJNoticeMenu hide];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
//    tableArrayData = nil;
    NSLog(@"内存警告");
//    if (self.isViewLoaded && !self.view.window)
//    {
//        self.view = nil;
//    }
//    [[SDImageCache sharedImageCache] clearDisk];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - CustomMethod


-(void)dealloc{
    [headerView free];
    [footView free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

//字符串转时间戳
- (NSString *)stringConversionDateTime:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";//指定转date得日期格式化形式
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    [dateFormatter setTimeZone:zone];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    return timeString;
}



//段标题随cell滚动
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat sectionHeaderHeight = 31;
//    
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        
//    }
//    
//}
@end
