//
//  WorkApplyRecordController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/15.
//  Copyright © 2018年 TW. All rights reserved.
//申请记录

#import "WorkApplyRecordController.h"
#import "WorkApplyRecodCell.h"
#import "WorkTimeTableViewCell.h"
#import "AutheTimeListModel.h"
#import "MotoRoomModel.h"
#import "MJExtension.h"
#import "DataUtility.h"
#import "CustPickerView.h"

static NSString *const WorkTimeCell = @"WorkTimeTableViewCell";

@interface WorkApplyRecordController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,MJRefreshBaseViewDelegate>
@property(nonatomic,strong)UITableView *maintableView;
@property(nonatomic, strong) UITextField *motoRoom_Field;
@property (nonatomic,weak) UIButton *checkRoomBtn;
@property (nonatomic,weak) UIImageView *arrow_image;
@property (nonatomic,strong)NSMutableArray *dataSouceArray;
@property (nonatomic,strong)UIView *tableViewHeader;
@end

@implementation WorkApplyRecordController
{
    int roomTimeCount;
    MJRefreshHeaderView *headView;
    MJRefreshFooterView *footView;
    NSMutableArray *roomLockNo_arry;  //机房编号数组
    NSMutableArray *roomName_arry;    //机房名称
    NSMutableArray *roomID_arry;      //机房ID数组
    NSNumber *numId;                  //机房id
    NSString *phoneNum;
    UIButton *roomNameBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    phoneNum = [ud objectForKey:@"iphoneNumber"];
    [self creatNavigation];
    [self creatTabaleView];
    _dataSouceArray = [[NSMutableArray alloc]initWithCapacity:0];
    roomName_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomID_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomLockNo_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomTimeCount = 1;
   
    [self requestQueryRoomByUser]; //获取申请过权限的机房
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(rebackToRootViewAction)];
    self.title_lbl.text = @"申请记录";
}

#pragma mark - CreatUI
- (void)creatTabaleView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _maintableView.backgroundColor = HexRGB(0xeeeeee);
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    _maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_maintableView setTableHeaderView:self.tableViewHeader];
    [self.view addSubview:_maintableView];
    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_maintableView];
    footView = [[MJRefreshFooterView alloc]initWithScrollView:_maintableView];
    headView.delegate = self;
    footView.delegate = self;
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
    __weak typeof (self)weakSelf = self;
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
                [roomNameBtn setTitle:roomName_arry[0] forState:UIControlStateNormal];
                numId = roomID_arry[0];
                [roomLockNo_arry addObject:model.lock_no];
             
            }
          [weakSelf requestQueryUserbyTelWithRoomId:numId]; //获取授权时限
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark - 获取机房时限列表  申请记录
- (void)requestQueryUserbyTelWithRoomId:(NSNumber *)roomId
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomOrderListByTel];
    NSDictionary *parameters = @{@"token":usertoken,@"type":[NSNumber numberWithInteger:areaType],@"roomId":roomId,@"pageNum":[NSNumber numberWithInt:roomTimeCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"机房时限列表==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (roomTimeCount == 1) {
                [_dataSouceArray removeAllObjects];
            }
            if ([jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue] == 0) {
                [self.dataSouceArray removeAllObjects];
                [SVProgressHUD showInfoWithStatus:@"没有授权信息"];
            }
            if (roomTimeCount>[jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue]) {
                if([footView isRefreshing]){
                    [footView endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headView isRefreshing])
                {
                    [headView endRefreshing];
                }
                return ;
            }
            NSArray *listArray = jsonObj[@"message"][@"roomOrderList"][@"list"];
            for(NSDictionary *dic in listArray)
            {
                AutheTimeListModel *model = [AutheTimeListModel mj_objectWithKeyValues:dic];
                [_dataSouceArray addObject:model];
            }
            [_maintableView reloadData];
            
        }
        if([footView isRefreshing]){
            [footView endRefreshing];
        }else if ([headView isRefreshing])
        {
            [headView endRefreshing];
        }
        
        
    } Error:^(NSString *errMsg, id jsonObj) {
        if([footView isRefreshing]){
            [footView endRefreshing];
        }else if ([headView isRefreshing])
        {
            [headView endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark -----tableViewDelegate-------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        return _dataSouceArray.count;
 
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTimeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkTimeCell];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:WorkTimeCell owner:self options:nil][0] ;
    }
        AutheTimeListModel *model;
        if (_dataSouceArray.count>0) {
            model = [_dataSouceArray objectAtIndex:indexPath.row];
            cell.listModel = model;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkTimeTableViewCell *cell = (WorkTimeTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *section_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29)];
    section_view.backgroundColor = HexRGB(0xeeeeee);
    
    UIView *topSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
    [section_view addSubview:topSeperaView];
    
    UIView *bottomSeperaView = [[UIView alloc]initWithFrame:CGRectMake(0, 28.5, SCREEN_WIDTH, 0.5)];
    bottomSeperaView.backgroundColor = COLOR_RGB(200, 199, 204);
    [section_view addSubview:bottomSeperaView];
    
    UILabel *section_lbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 100, section_view.height)];
    section_lbl.font = Font(12);
    section_lbl.textColor = HexRGB(0x999999);
    [section_view addSubview:section_lbl];

    bottomSeperaView.hidden = YES;
    section_lbl.text = @"机房授权时限";

    return section_view;
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (headView == refreshView) {
        roomTimeCount = 1;
        [self requestQueryUserbyTelWithRoomId:numId];
    }else if (footView == refreshView){
        roomTimeCount ++;
        [self requestQueryUserbyTelWithRoomId:numId];
    }
}

- (UIView *)tableViewHeader
{
    CGFloat ImageWith = (SCREEN_WIDTH-36-48)/2;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 84)];
    backView.backgroundColor = HexRGB(0xeeeeee);
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 29)];
    title_lbl.text = @"授权机房";
    title_lbl.font = Font(12);
    title_lbl.textColor = HexRGB(0x999999);
    [backView addSubview:title_lbl];
    
    UIView *seachrView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 55)];
    seachrView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:seachrView];
    
    roomNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [roomNameBtn setBackgroundImage:[UIImage imageNamed:@"搜索选择时间"] forState:UIControlStateNormal];
    [roomNameBtn setTitle:@"暂无机房信息" forState:UIControlStateNormal];
    roomNameBtn.titleLabel.font = Font(12);
    [roomNameBtn setTitleColor:HexRGB(0x333333) forState:UIControlStateNormal];
    [roomNameBtn addTarget:self action:@selector(selectRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [seachrView addSubview:roomNameBtn];
    
    [roomNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seachrView.mas_left).offset(18);
        make.top.equalTo(seachrView.mas_top).offset(10);
        make.width.mas_equalTo(ImageWith);
        make.height.mas_equalTo(35);
    }];

    return backView;
}


#pragma mark ------选择机房------
- (void)selectRoomBtn:(UIButton *)btn
{
    _arrow_image.image = [UIImage imageNamed:@"上拉"];
    if (roomName_arry.count>0) {
        __weak typeof (self)weakSelf = self;
        CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:roomName_arry];
        [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger num) {
            [roomNameBtn setTitle:selectedDate forState:UIControlStateNormal];
            _arrow_image.image = [UIImage imageNamed:@"下拉"];
            
            numId = [roomID_arry objectAtIndex:num];
            [weakSelf requestQueryUserbyTelWithRoomId:numId];
            
        }];
    }
}


#pragma mark - -------textFieldDelegate------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [_motoRoom_Field resignFirstResponder];
    _arrow_image.image = [UIImage imageNamed:@"上拉"];
    if (roomName_arry.count>0) {
        __weak typeof (self)weakSelf = self;
        CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:roomName_arry];
        [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger num) {
            _motoRoom_Field.text = selectedDate;
            _arrow_image.image = [UIImage imageNamed:@"下拉"];
            
            numId = [roomID_arry objectAtIndex:num];
            [weakSelf requestQueryUserbyTelWithRoomId:numId];
            
        }];
    }
  
}

- (void)rebackToRootViewAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [headView free];
    [footView free];
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
