//
//  WorkOrderHomeController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/8.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkOrderHomeController.h"
#import "SelectRoomViewController.h"
#import "MyCenterViewController.h"
#import "ResourceHomeController.h"
#import "HomePageViewController.h"
#import "SDCycleScrollView.h"
#import "WorkApplyViewController.h"
#import "ResouceCicleManageController.h"
#import "WorkApplyRecordController.h"
#import "MarketingCicleManageController.h"
#import "CustomWorkOrderView.h"
#import "WorkRecordViewController.h"
#import "SelectAreaCell.h"
#import "homePageBtn.h"
#import "AuthentifiModel.h"
#import "MJExtension.h"
#import "DataUtility.h"
#import "Macro.h"
#import "AddressPickerHeader.h"
#import "CZHAddressPickerView.h"
#import "TabBarMainViewController.h"
#import "TJTongwangWorkView.h"
#import "LoginViewController.h"

static NSString *const selectAreaCell = @"SelectAreaCell";

const NSInteger custBtnHeigth = 60;
@interface WorkOrderHomeController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UITextFieldDelegate,CustomWorkOrderManageDelegat,SelectRoomViewDelegate,TJTongwangWorkViewDelegat>
@property (nonatomic,strong)TabBarMainViewController *tabVC;
@property(nonatomic,strong)UITableView *maintableView;
@property (strong, nonatomic) homePageBtn *titleBtn;
@property(nonatomic, weak) UITextField *area_Field;
@property(nonatomic, weak) UIButton *refreshBtn;
@property (nonatomic,weak) UIImageView *arrow_image;
@property (nonatomic,weak) UIButton *selectRoom_Btn;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *area;
@property (nonatomic,strong)UILabel *message_noe;
@property (nonatomic,strong)UILabel *message_two;
@property (nonatomic,strong)UILabel *message_thrd;
@end

@implementation WorkOrderHomeController
{
    SDCycleScrollView *cycleScrollView;
    NSString *lockName; //保存回调的机房名
    NSString *lockId;   //保存回调的机房ID
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [cycleScrollView adjustWhenControllerViewWillAppera];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.province = @"";
    self.city = @"";
    self.area = @"";
    [self initNavBar];
    [self setTopviewUI];

    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
     [self requestQueryCheckUserState]; //查询权限
    });
}

#pragma mark - 设置导航栏控件
- (void)initNavBar
{
    //导航栏标题
    _titleBtn = [[homePageBtn alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
    [_titleBtn setTitle:@"工单管理系统" forState:UIControlStateNormal];
    
    [_titleBtn setTitleColor:COLOR_RGB(79, 172, 246) forState:UIControlStateNormal];
    
    self.navigationItem.titleView = _titleBtn;
    
    
}


#pragma mark - topView
-(void)setTopviewUI{
    cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 161) delegate:self placeholderImage:[UIImage imageNamed:@"金沙花园135.jpg"]];
    cycleScrollView.pageControlBottomOffset = 10;
    cycleScrollView.currentPageDotColor = HexRGB(0x4facf6);
    cycleScrollView.pageDotColor = HexRGB(0xc2c2c2);
    
    CGFloat height;
    if (areaType == 6||areaType == 9) {
        height = SCREEN_HEIGHT - 49;
    }else{
        height = SCREEN_HEIGHT;
    }
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, height) style:UITableViewStylePlain];
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    _maintableView.tableHeaderView = cycleScrollView;
    _maintableView.tableFooterView = [UIView new];
    _maintableView.backgroundColor = COLOR_RGB(237, 237, 240);
    [self.view addSubview:_maintableView];
    
    UINib *nib = [UINib nibWithNibName:selectAreaCell bundle:nil];
    [_maintableView registerNib:nib forCellReuseIdentifier:selectAreaCell];

    
    if (!usertoken) {
        
    }else{
        
        cycleScrollView.imageURLStringsGroup = @[@"智能门锁Banner"];
      NSString *lockName = [[NSUserDefaults standardUserDefaults] objectForKey:@"lockName"];
        [self.refreshBtn setTitle:lockName forState:UIControlStateNormal];
    }
    
    
}

#pragma mark - 查询用户是什么权限  1、通网  6、管理员 8、其他 9、领导7、物业
- (void)requestQueryCheckUserState
{
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryCheckUser];
    
    NSDictionary *parameters = @{@"token":usertoken};
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD dismiss];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
        NSLog(@"查询用户是否为认证用户==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSDictionary *dic = jsonObj[@"message"][@"constructionUserVO"];
            AuthentifiModel *model = [AuthentifiModel mj_objectWithKeyValues:dic];

            areaType = model.type;
            realName = model.realName;
            if (areaType == 6 ||areaType == 9) {
                self.tabVC = [[TabBarMainViewController alloc]init];
                app.window.rootViewController = self.tabVC;
                
            }else{
               
                WorkOrderHomeController *vc = [[WorkOrderHomeController alloc]init];
                UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
                app.window.rootViewController = nav;
                
            }
        }else{
             [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
            AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
            LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
            delegate.window.rootViewController = nav;
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark - tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        /*
        SelectAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:selectAreaCell];
        _area_Field = cell.selectArea_fiedl;
        _arrow_image = cell.arrowImage;
        _refreshBtn = cell.selectRoomBtn;
        _area_Field.delegate = self;
        NSString *lockName = [[NSUserDefaults standardUserDefaults] objectForKey:@"saveLockName"];
        if (![DataUtility isBlankObject:lockName]) {
            [cell.selectRoomBtn setTitle:lockName forState:UIControlStateNormal];
        }
        
        [cell.selectRoomBtn addTarget:self action:@selector(clickSelectRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
         */
        static NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.contentView addSubview:self.message_noe];
            [cell.contentView addSubview:self.message_two];
            [cell.contentView addSubview:self.message_thrd];
            self.message_noe.frame = CGRectMake(13, 10, SCREEN_WIDTH-26, [self stringHeightWithMessageWithMessage:self.message_noe.text]);
            self.message_two.frame = CGRectMake(13, CGRectGetMaxY(self.message_noe.frame)+5, SCREEN_WIDTH-26, [self stringHeightWithMessageWithMessage:self.message_two.text]);
            self.message_thrd.frame = CGRectMake(13, CGRectGetMaxY(self.message_two.frame)+5, SCREEN_WIDTH-26, [self stringHeightWithMessageWithMessage:self.message_thrd.text]);
            
        }
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        if (areaType == 6 ||areaType == 9||areaType == 8) {
            for(UIView *view in cell.contentView.subviews){
                [view removeFromSuperview];
            }
            CustomWorkOrderView *custBtnView = [[CustomWorkOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200+1)];
            custBtnView.delegate = self;
            
            [cell.contentView addSubview:custBtnView];
        }else{
            for(UIView *view in cell.contentView.subviews){
                [view removeFromSuperview];
            }
            TJTongwangWorkView *custBtnView = [[TJTongwangWorkView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200+1)];
            custBtnView.delegate = self;
            
            [cell.contentView addSubview:custBtnView];

        }
        
        
        return cell;
        
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        return 105;
        return [self stringHeightWithMessageWithMessage:[self message]]+30;
    }else{
        if (areaType == 6 ||areaType == 9||areaType == 8) {
        return 92*2+1.5;
        }else{
            return 92+1;
        }
            

    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    headView.backgroundColor = COLOR_RGB(237, 237, 240);
    
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 5, SCREEN_WIDTH, 21)];
    title_lbl.font = [UIFont systemFontOfSize:14];
    title_lbl.textColor = COLOR_RGB(102, 102, 102);
    if (section == 0) {
        title_lbl.text = @"工单相关说明";
    }else if(section == 1){
        title_lbl.text = @"工单相关操作";
    }
    
    [headView addSubview:title_lbl];
    return headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}

- (NSString *)message
{
    NSString *str = @"1、通网公司全部合作机房统一采用工单管理；\n2、各个运营商、物业等合作伙伴需要进出机房统一使用工单管理操作；\n3、申请成功后，通网会及时审批，请通过申请记录查看具体结果。";
    return str;
}

- (CGFloat )stringHeightWithMessageWithMessage:(NSString *)text
{
    CGSize strSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-36, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return strSize.height;
}

#pragma mark --- 选择工单按钮的Delegate ------
- (void)selectWorkOrderManegeBtnTag:(NSInteger)tag
{
    switch (tag) {
        case 4000:
        {
          //工单申请
            WorkApplyViewController *vc = [[WorkApplyViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4001:
            //申请记录
        {
            WorkApplyRecordController *vc = [[WorkApplyRecordController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 4002:{
            //个人中心
            MyCenterViewController *vc = [[MyCenterViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            case 4003:
            //工单记录
        {
            if (areaType == 6 ||areaType == 9||areaType == 8) {
                WorkRecordViewController *vc = [[WorkRecordViewController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case 4004:{
            //授权管理
            if (areaType == 6||areaType == 9) {//管理员、领导
                ResouceCicleManageController *vc = [[ResouceCicleManageController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }else if(areaType == 8){//营销人员
                MarketingCicleManageController *vc = [[MarketingCicleManageController alloc]init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }
            break;
        default:
            break;
    }
}

- (void)selectTongwangWorkBtnTag:(NSInteger)tag
{
    switch (tag) {
        case 4000:
        {
            //工单申请
            WorkApplyViewController *vc = [[WorkApplyViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case 4001:
            //申请记录
        {
            WorkApplyRecordController *vc = [[WorkApplyRecordController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
        case 4002:{
            //个人中心
            MyCenterViewController *vc = [[MyCenterViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark --- 选择机房回调Delegate ------
- (void)callBackRoomInfomationWithDic:(NSDictionary *)dic
{
    lockName = dic[@"name"];
    [[NSUserDefaults standardUserDefaults] setObject:lockName forKey:@"saveLockName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
//    lockId = dic[@"roomId"];
    NSNumber *rooID = dic[@"roomId"];
    lockId =  [rooID stringValue];
    portRoomID = [rooID stringValue];
    
    [self.refreshBtn setTitle:lockName forState:UIControlStateNormal];
}

#pragma mark ---选择机房--------
- (void)clickSelectRoomBtn:(UIButton *)btn
{
    SelectRoomViewController *vc = [[SelectRoomViewController alloc]init];
    if ([lockId isEqualToString:@""]) {
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        vc.delegate =self;
        vc.selectProvince = YES;
        vc.province = self.province;
        vc.city = self.city;
        vc.area = self.area;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_area_Field resignFirstResponder];
    _arrow_image.image = [UIImage imageNamed:@"上拉"];
    __weak typeof (self)weakSealf = self;
    [CZHAddressPickerView areaPickerViewWithProvince:self.province city:self.city area:self.area areaBlock:^(NSString *province, NSString *city, NSString *area) {
        weakSealf.arrow_image.image = [UIImage imageNamed:@"下拉"];
        weakSealf.province = province;
        weakSealf.city = city;
        weakSealf.area = area;
        SelectRoomViewController *vc = [[SelectRoomViewController   alloc]init];
        vc.selectProvince = YES;
        vc.province = province;
        vc.city = city;
        vc.area = area;
        vc.delegate =self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        _area_Field.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
    }];
}

- (UILabel *)message_noe
{
    if (!_message_noe) {
        _message_noe = [[UILabel alloc]init];
        _message_noe.textColor = HexRGB(0x4facf6);
        _message_noe.numberOfLines = 0;
        _message_noe.font = Font(15);
        _message_noe.text = @"1、通网公司全部合作机房统一采用工单管理；";
    }
    
    return _message_noe;
}

- (UILabel *)message_two
{
    if (!_message_two) {
        _message_two = [[UILabel alloc]init];
        _message_two.textColor = HexRGB(0x4facf6);
        _message_two.numberOfLines = 0;
        _message_two.font = Font(15);
        _message_two.text = @"2、各个运营商、物业等合作伙伴需要进出机房统一使用工单管理操作；";
    }
    return _message_two;
}

- (UILabel *)message_thrd
{
    if (!_message_thrd) {
        _message_thrd = [[UILabel alloc]init];
        _message_thrd.textColor = HexRGB(0x4facf6);
        _message_thrd.numberOfLines = 0;
        _message_thrd.font = Font(15);
        _message_thrd.text = @"3、申请成功后，通网会及时审批，请通过申请记录查看具体结果。";
    }
    return _message_thrd;
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
