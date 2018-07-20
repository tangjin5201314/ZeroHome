//
//  ResourceHomeController.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "ResourceHomeController.h"
#import "homePageBtn.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "SelectAreaCell.h"
#import "AddressPickView.h"
#import "ManageRoomCell.h"
#import "ManageRoomListController.h"
#import "RoomInfoTableViewCell.h"
#import "SelectRoomViewController.h"
#import "MyCenterViewController.h"
#import "PortInformationController.h"
#import "DataUtility.h"
#import "EquipMentListModel.h"
#import "MJExtension.h"
#import "AddressPickerHeader.h"
#import "CZHAddressPickerView.h"
#import "AddressQueryViewController.h"

static NSString *const selectAreaCell = @"SelectAreaCell";
static NSString *const RoomInfoCell = @"RoomInfoTableViewCell";

@interface ResourceHomeController ()<SDCycleScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,selectManageButtonDelegat,SelectRoomViewDelegate,SelectAreaCellDelegat>
@property (strong, nonatomic) homePageBtn *titleBtn;
@property (strong, nonatomic) UIButton *rightBarItme;
@property(nonatomic,strong)UITableView *maintableView;

@property(nonatomic, weak) UIButton *selectAreaBtn;
@property(nonatomic, weak) UIButton *refreshBtn;
@property (nonatomic,weak) UIImageView *arrow_image;
@property (nonatomic,weak) UIButton *selectRoom_Btn;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *area;
@end

@implementation ResourceHomeController
{
     SDCycleScrollView *cycleScrollView;
    EquipMentListModel *model;
    NSString *lockName;
    NSString *lockId;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [cycleScrollView adjustWhenControllerViewWillAppera];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [self topview];
    
    self.province = @"广东省";
    self.city = @"深圳市";
    self.area = @"宝安区";
}

#pragma mark - 设置导航栏控件
- (void)initNavBar
{
    //导航栏标题
    _titleBtn = [[homePageBtn alloc]initWithFrame:CGRectMake(0, 5, 50, 30)];
    [_titleBtn setTitle:@"资源管理系统" forState:UIControlStateNormal];
    
    [_titleBtn setTitleColor:COLOR_RGB(79, 172, 246) forState:UIControlStateNormal];
    
    self.navigationItem.titleView = _titleBtn;
    
//    [self setRightButtonWithTitle:@"智能门锁" action:@selector(rightBtn:)];
    
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
    
    UINib *nib = [UINib nibWithNibName:selectAreaCell bundle:nil];
    [_maintableView registerNib:nib forCellReuseIdentifier:selectAreaCell];
//
    UINib *nib1 = [UINib nibWithNibName:RoomInfoCell bundle:nil];
    [_maintableView registerNib:nib1 forCellReuseIdentifier:RoomInfoCell];
    
    if (!usertoken) {
        
    }else{
        
        cycleScrollView.imageURLStringsGroup = @[@"bannerWork"];
    }
    
    
}

#pragma mark - 获取机房详细信息

- (void)requestQueryRoomDetailInfomation
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KManageRoomById];
    if (![DataUtility isBlankObject:lockId] ) {
        NSDictionary *parameters = @{@"token":usertoken,@"id":lockId};
        NSLog(@"xxxx==%@",parameters);
        [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
            
            NSLog(@"获取机房详细信息==:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"]boolValue]){
            NSDictionary *dic = jsonObj[@"message"][@"room"];
            model = [EquipMentListModel mj_objectWithKeyValues:dic];
              
            }else{
                [SVProgressHUD showInfoWithStatus:@"暂无机房信息"];
            }
            [self.maintableView reloadData];
        } Error:^(NSString *errMsg, id jsonObj) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
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
        SelectAreaCell *cell = [tableView dequeueReusableCellWithIdentifier:selectAreaCell];
//        _area_Field = cell.selectArea_fiedl;
        _selectAreaBtn = cell.selectAreaBtn;
        _arrow_image = cell.arrowImage;
        _refreshBtn = cell.selectRoomBtn;
//        _area_Field.delegate = self;
        cell.delegate = self;
        [cell.selectRoomBtn addTarget:self action:@selector(clickSelectRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        ManageRoomCell *custBtnView = [[ManageRoomCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100+1)];
        custBtnView.delegate = self;
        
        [cell.contentView addSubview:custBtnView];

        return cell;
        
    }else{
        RoomInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RoomInfoCell];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 105;
    }else if(indexPath.section == 1){
        return 92+1.5;
    }else{
        return 150;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    headView.backgroundColor = COLOR_RGB(237, 237, 240);
    
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 5, (SCREEN_WIDTH-26)*0.5, 21)];
    title_lbl.font = [UIFont systemFontOfSize:14];
    title_lbl.textColor = COLOR_RGB(102, 102, 102);
   
    UILabel *detal_lbl = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title_lbl.frame), 5, (SCREEN_WIDTH-26)*0.5, 21)];
    detal_lbl.textAlignment = NSTextAlignmentRight;
    detal_lbl.userInteractionEnabled = YES;
    detal_lbl.tag = section;
    detal_lbl.font = [UIFont systemFontOfSize:14];
    detal_lbl.textColor = HexRGB(0x4facf6);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(queryAddress:)];
    [detal_lbl addGestureRecognizer:tap];
    
    if (section == 0) {
        title_lbl.text = @"您当前选中的机房";
    }else if(section == 1){
        title_lbl.text = @"机房相关操作";
    }else{
        title_lbl.text = @"该机房的信息";
        detal_lbl.text = @"地址查询";
    }
    [headView addSubview:title_lbl];
    [headView addSubview:detal_lbl];
    return headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}

- (void)queryAddress:(UITapGestureRecognizer *)tap
{
    if (tap.view.tag == 2) {
        NSLog(@"地址查询");
        if (![DataUtility isBlankObject:lockName]) {
            AddressQueryViewController *vc = [[AddressQueryViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.roomID = [lockId integerValue];
            vc.lockName = lockName;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        else{
            [SVProgressHUD showInfoWithStatus:@"请先选择机房"];
        }
        
    }
}

- (void)selectManageBtnTag:(NSInteger)tag
{
    if (tag == 3000) {
        if (![DataUtility isBlankObject:lockName]) {
             [self requestQueryRoomDetailInfomation];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请先选择机房"];
        }
    }else if (tag == 3001){
        if (![DataUtility isBlankObject:lockName]) {
            ManageRoomListController *vc = [[ManageRoomListController alloc]init];
            vc.lockRoomId = lockId;
            portRoomID = lockId ;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVProgressHUD showInfoWithStatus:@"请先选择机房"];
        }
        
    }else if (tag == 3002){
        MyCenterViewController *vc = [[MyCenterViewController alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)selectAreaBtnTag:(NSInteger)tag
{
    __weak typeof (self)weakSealf = self;
    [CZHAddressPickerView areaPickerViewWithProvince:self.province city:self.city area:self.area areaBlock:^(NSString *province, NSString *city, NSString *area) {
        weakSealf.arrow_image.image = [UIImage imageNamed:@"下拉"];
        weakSealf.province = province;
        weakSealf.city = city;
        weakSealf.area = area;
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
        [weakSealf.navigationController pushViewController:vc animated:YES];
        NSString *areaStr = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
        [weakSealf.selectAreaBtn setTitle:areaStr forState:UIControlStateNormal];
    }];

}

#pragma mark - -------textFieldDelegate------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//    [_area_Field resignFirstResponder];
    _arrow_image.image = [UIImage imageNamed:@"上拉"];
    
    __weak typeof (self)weakSealf = self;
    [CZHAddressPickerView areaPickerViewWithProvince:self.province city:self.city area:self.area areaBlock:^(NSString *province, NSString *city, NSString *area) {
         weakSealf.arrow_image.image = [UIImage imageNamed:@"下拉"];
        weakSealf.province = province;
        weakSealf.city = city;
        weakSealf.area = area;
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
        [weakSealf.navigationController pushViewController:vc animated:YES];
//        weakSealf.area_Field.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,area];
    }];
    
  
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
        vc.province = @"";
        vc.city = @"";
        vc.area = @"";
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];

    }
    
    
}

- (void)callBackRoomInfomationWithDic:(NSDictionary *)dic
{
    lockName = dic[@"name"];
    NSNumber *num = dic[@"roomId"];
    lockId = [num stringValue];
    [self.refreshBtn setTitle:lockName forState:UIControlStateNormal];
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
