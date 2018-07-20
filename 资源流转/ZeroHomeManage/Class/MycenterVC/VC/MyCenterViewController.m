//
//  MyCenterViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "MyCenterViewController.h"
#import "CenterTableViewCell.h"
#import "SettingViewController.h"
#import "UserSetViewController.h"
#import "UMSocial.h"
#import "NSString+category.h"
#import "UIButton+WebCache.h"
#import "UIUtility.h"
#import "registeredViewController.h"
#import "Masonry.h"
#import "LoginViewController.h"
#import "userCenterModel.h"
#import "ResetPassWordViewController.h"

@interface MyCenterViewController ()<UMSocialUIDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic,strong) UIView *creatHeadView;
@property (nonatomic,strong)NSDictionary *myDic;
@property (nonatomic,strong)NSString *pathImage;
@end

@implementation MyCenterViewController{
    NSArray *titleArr;
    NSArray *ImageArr;
    
    MJRefreshFooterView *FootView;
    MJRefreshHeaderView *HeadView;
    
    UIImageView *navBarHairlineImageView;
    
    userCenterModel *centerModel;
}

- (void)refreshData:(NSNotification *)dic
{
    [self loadData];
    [_CenterTabelView reloadData];
}

- (void)refreshCommitNotification:(NSNotification *)dic
{
//    NSInteger commentNum = [centerModel.validPoint integerValue]+1;
//    centerModel.validPoint = [NSString stringWithFormat:@"%ld",(long)commentNum];
    [self loadData];
    [self.CenterTabelView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //隐藏导航栏下面线条
    navBarHairlineImageView.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title_lbl.text = @"我的";
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
     titleArr = [[NSArray alloc]init];
     titleArr = @[@[@"service",@"我的客服"],@[@"change-",@"修改资料"],@[@"setting",@"设置"]];
    
    
    //修改头像通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"REFRESHFIXHEAD" object:nil];
    
    //隐藏导航栏下面线条
//    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];

    [self CreatUI];
    
    if (!usertoken) {
        [_LoginRsg setImage:[UIImage imageNamed:@"默认头像"] forState:UIControlStateNormal];
        _nickName.text = @"您未登录，前往登录！";
        
    }else{
        [self loadData];
    }
}
-(void)loadData{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kMine];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:usertoken,@"token", nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"个人中心:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if ([HeadView isRefreshing]) {
                [HeadView endRefreshing];
            }
            centerModel = [[userCenterModel alloc]initWith:[jsonObj objectForKey:@"message"]];
            
            _pathImage = [centerModel.headPortrait stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _myDic = [jsonObj objectForKey:@"message"];
            _nickName.text = centerModel.nickname;
            //获取用户名
            userName = centerModel.nickname;
            [_LoginRsg sd_setBackgroundImageWithURL:[NSURL URLWithString:_pathImage] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"person.png"]];
            _conponLevel.text = [NSString stringWithFormat:@"会员等级：Lv%@",centerModel.pointLevel];
            _integral_lbl.text = [NSString stringWithFormat:@"我的积分：%@",centerModel.validPoint];
            
            NSInteger sexInt = [centerModel.sex integerValue];
            if (!sexInt) {
                _sexImage.image = [UIImage imageNamed:@"male"];
            }else
            {
                _sexImage.image = [UIImage imageNamed:@"female"];
            }
            [_CenterTabelView reloadData];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        if ([HeadView isRefreshing]) {
            [HeadView endRefreshing];
        }

        ;
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
    
    
    
}
-(void)CreatUI{
    
    _CenterTabelView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-49) style:UITableViewStyleGrouped];
    _CenterTabelView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    _CenterTabelView.delegate = self;
    _CenterTabelView.dataSource = self;
    [_CenterTabelView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:_CenterTabelView];
    _CenterTabelView.tableHeaderView = self.creatHeadView;
    
}


#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return titleArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    CenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"CenterTableViewCell" owner:self options:nil][0];
           NSArray *arr = titleArr[indexPath.section];
        cell.titleLabel.text = arr[1];
        cell.imageview.image = [UIImage imageNamed:arr[0]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 49.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
                    {
                        NSLog(@"我的客服");
                        NSString *phone = @"400-8333-201";
                        UIWebView*callWebview =[[UIWebView alloc] init];
                        NSString *telUrl = [NSString stringWithFormat:@"tel:%@",phone];
                        
                        NSURL *telURL =[NSURL URLWithString:telUrl];
                        
                        [callWebview loadRequest:[NSURLRequest requestWithURL:telURL]];
                        
                        //记得添加到view上
                        
                        [self.view addSubview:callWebview];
                    }

                    break;

        case 1:

                    [self PushEditeZiliao];

            break;
        case 2:

          [self PushSettingVC];
            break;
    }
    
}

#pragma PUSH
//个人主页
- (void)PushMyShareInfo
{
    if (!usertoken) {
        AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
        LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
        delegate.window.rootViewController = nav;
        
    }else{
      
 
    }
}


-(void)PushSettingVC{
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"app_Center_Setting"};
    [MobClick event:@"app_Center_Setting" attributes:dict];

//    if(!self.user.isLogin){
//        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"您还未登陆"];
//    }else{
        SettingViewController *setVC = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
        setVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setVC animated:YES];
//    }
}



//编辑资料
- (void)PushEditeZiliao
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    if(!usertoken){
        [SVProgressHUD showInfoWithStatus:@"您未登录"];
    }else{
        if(self.user.isThirdLogin){
            if(self.user.isPerfect){
                UserSetViewController *UserSet = [[UserSetViewController alloc]initWithNibName:@"UserSetViewController" bundle:nil];
                UserSet.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:UserSet animated:YES];
            }else{
                [UIUtility showWith:@"提示" message:@"您还未完善资料,是否去完善?" delegate:self canceltitle:@"暂不完善" otherButtonTitles:@"去完善" tag:50];
                
            }
        }else{
            UserSetViewController *UserSet = [[UserSetViewController alloc]initWithNibName:@"UserSetViewController" bundle:nil];
            UserSet.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:UserSet animated:YES];
        }
        
    }

}


//#pragma mark - UIAlertView
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if(alertView.tag!=50){
//        return;
//    }
//    if(buttonIndex==1){
//        NSLog(@"完善");
//        ResetPassWordViewController *vc = [[ResetPassWordViewController alloc]init];
//        vc.isPerfectData = YES;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//}

- (void)clickHead:(UIButton *)btn
{
    [self PushEditeZiliao];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MJRefresh
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if(refreshView==HeadView){
        [self loadData];
    }
}

- (UIView *)creatHeadView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 102 + 18)];
    headView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];

    UIView *seperatView = [[UIView alloc]initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 102)];
    seperatView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:seperatView];
    //顶部分割线
    
    UIView *topSeperat = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 0.5)];
    topSeperat.backgroundColor = COLOR_RGB(200, 199, 204);
    [headView addSubview:topSeperat];
    //底部分割线
    UIView *botomSeperat = [[UIView alloc]initWithFrame:CGRectMake(0, 18, SCREEN_WIDTH, 0.5)];
    botomSeperat.backgroundColor = COLOR_RGB(200, 199, 204);
    [headView addSubview:botomSeperat];
    
    _LoginRsg = [[UIButton alloc]initWithFrame:CGRectMake(16, (102-76)/2, 76, 76)];
    _LoginRsg.tag = 1004;
    [_LoginRsg.layer setMasksToBounds:YES];
    [_LoginRsg addTarget:self action:@selector(clickHead:) forControlEvents:UIControlEventTouchUpInside];
    _LoginRsg.contentMode = UIViewContentModeScaleAspectFill;
    [_LoginRsg.layer setCornerRadius:38];
    [seperatView addSubview:_LoginRsg];

    //基本信息
    _nickName = [[UILabel alloc]initWithFrame:CGRectZero];
    _nickName.textColor = COLOR_RGB(51, 51, 51);
    _nickName.font = [UIFont systemFontOfSize:17];
    [seperatView addSubview:_nickName];
 
    
    _sexImage = [[UIImageView alloc]initWithFrame:CGRectZero];
    [seperatView addSubview:_sexImage];
    [_sexImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nickName.mas_right).offset(6);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(seperatView.mas_centerY).offset(-12);
    }];
    
    
    if (usertoken) {
        //会员等级
        _conponLevel = [[UILabel alloc]initWithFrame:CGRectZero];
        _conponLevel.textColor = COLOR_RGB(255, 128, 26);
        _conponLevel.font = FONT_SYSTEM(13);
        [seperatView addSubview:_conponLevel];
        
        UIView *sepaView = [[UIView alloc]initWithFrame:CGRectZero];
        sepaView.backgroundColor = COLOR_RGB(144, 144, 144);
        [seperatView addSubview:sepaView];
        
        [_conponLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_LoginRsg.mas_right).offset(14);
            make.top.equalTo(_nickName.mas_bottom).offset(12);
        }];
        
        //会员积分
        _integral_lbl = [[UILabel alloc]initWithFrame:CGRectZero];
        _integral_lbl.textColor = COLOR_RGB(168, 168, 168);
        _integral_lbl.font = FONT_SYSTEM(13);
        [seperatView addSubview:_integral_lbl];
        [_integral_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_conponLevel.mas_right).offset(14);
            make.top.equalTo(_nickName.mas_bottom).offset(12);
            make.right.mas_lessThanOrEqualTo(seperatView).offset(-18);
        }];
        
        [sepaView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_conponLevel.mas_right).offset(7);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(18);
            make.top.equalTo(_conponLevel.mas_top);
        }];


        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_LoginRsg.mas_right).offset(14);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(seperatView.mas_centerY).offset(-12);
        }];

    }else{
        [_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_LoginRsg.mas_right).offset(14);
            make.height.mas_equalTo(20);
            make.centerY.equalTo(seperatView.mas_centerY);
        }];
    }

    return headView;
}

//去掉导航栏下面线条
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [FootView free];
    [HeadView free];
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
