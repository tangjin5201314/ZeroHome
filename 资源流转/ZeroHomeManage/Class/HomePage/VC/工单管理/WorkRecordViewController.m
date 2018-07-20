 //
//  WorkRecordViewController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/19.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "WorkRecordViewController.h"
#import "AutheTimeListModel.h"
#import "MotoRoomModel.h"
#import "MJExtension.h"
#import "DataUtility.h"
#import "CustPickerView.h"
#import "WorkRecordTableViewCell.h"
#import "WorkRoomTableViewCell.h"
#import "MHDatePicker.h"

@interface WorkRecordViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UITableView *maintableView;
@property(nonatomic, strong) UITextField *motoRoom_Field;
@property (nonatomic,weak) UIButton *checkRoomBtn;
@property (nonatomic,weak) UIImageView *arrow_image;
@property (nonatomic,strong)NSMutableArray *dataSouceArray;
@property (nonatomic,strong)UIView *tableViewHeader;
@property (strong, nonatomic) MHDatePicker *startPicker;
@property (strong, nonatomic) MHDatePicker *endDatePicker;
@end

@implementation WorkRecordViewController
{
    int roomTimeCount;
    MJRefreshHeaderView *headView;
    MJRefreshFooterView *footView;
    NSMutableArray *roomName_arry;    //机房名称
    NSMutableArray *roomID_arry;      //机房ID数组
    NSNumber *numId;  //机房id
    NSString *phoneNum;
    
    UITextField *startField;
    UITextField *endField;
    UIImageView *imageView; /*添加到搜索按钮上的动画图片*/
    UIButton *searchBtn;
    UIButton *roomNameBtn;

}

-(void)dealloc{
    [headView free];
    [footView free];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    phoneNum = [ud objectForKey:@"iphoneNumber"];
    _dataSouceArray = [[NSMutableArray alloc]initWithCapacity:0];
    roomName_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomID_arry = [[NSMutableArray alloc]initWithCapacity:0];
    roomTimeCount = 1;
    
    [self creatNavigation ];
    [self creatTabaleView];
    [self requestQueryRoomByUser];
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(rebackToRootViewAction)];
    self.title_lbl.text = @"工单记录";
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
                
            }
            [weakSelf requestQueryRoomByUserWithRoomId:numId]; //获取工单记录
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark -   //工单记录
- (void)requestQueryRoomByUserWithRoomId:(NSNumber *)rooId
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomWorkOderRecoderList];
    
     NSDictionary *parameters = @{@"token":usertoken,@"type":[NSNumber numberWithInteger:areaType],@"roomId":rooId,@"pageNum":[NSNumber numberWithInt:roomTimeCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"yyyyyy==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取工单记录==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (roomTimeCount == 1) {
                [_dataSouceArray removeAllObjects];
            }
            if ([jsonObj[@"message"][@"roomOrderList"][@"total"]intValue] == 0) {
                [SVProgressHUD showInfoWithStatus:@"没有工单记录"];
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
            
        }else{
            [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
        }
        if([footView isRefreshing]){
            [footView endRefreshing];
        }else if ([headView isRefreshing])
        {
            [headView endRefreshing];
        }
        
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark ----tableViewDelegate-------
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
    static NSString *cellID = @"WorkRecordTableViewCell";
    WorkRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WorkRecordTableViewCell" owner:self options:nil][0] ;
    }
        AutheTimeListModel *model;
        if (_dataSouceArray.count>0) {
            model = [_dataSouceArray objectAtIndex:indexPath.row];
            cell.listModel = model;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.text = @"暂无数据";
            return cell;
        }
        
        NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *startTime = [self stringConversionDateTime:dateTime] ;
        if ([model.endTime doubleValue]<[startTime doubleValue]) {
            cell.backgroundColor = HexRGB(0xf6f6f6);
            cell.startTime_lbl.textColor = HexRGB(0x999999);
            cell.endTime_lbl.textColor = HexRGB(0x999999);
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (_dataSouceArray.count>0) {
            return 122;
        }else{
            return 60;
        }
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
    section_lbl.text = @"机房工单记录";

    return section_view;
}

#pragma mark - -------textFieldDelegate------------
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == startField) {
        [startField resignFirstResponder];
        _startPicker = [[MHDatePicker alloc] init];
        _startPicker.isBeforeTime = YES;
        _startPicker.datePickerMode = UIDatePickerModeDate;
        __weak typeof(self) weakSelf = self;
        [_startPicker didFinishSelectedDate:^(NSDate *selectedDate) {
            startField.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        }];
    }else if (textField == endField)
    {
        [endField resignFirstResponder];
        _endDatePicker = [[MHDatePicker alloc] init];
        _endDatePicker.isBeforeTime = YES;
        _endDatePicker.datePickerMode = UIDatePickerModeDate;
        __weak typeof(self) weakSelf = self;
        [_endDatePicker didFinishSelectedDate:^(NSDate *selectedDate) {
            endField.text = [weakSelf dateStringWithDate:selectedDate DateFormat:@"yyyy-MM-dd"];
        }];
        
    }
    
}

- (void)selectRoomBtn:(UIButton *)btn
{
    _arrow_image.image = [UIImage imageNamed:@"上拉"];
    __weak typeof (self)weakSealf = self;
    if (roomName_arry.count>0) {
        CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:roomName_arry];
        [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger num) {
            [roomNameBtn setTitle:selectedDate forState:UIControlStateNormal];
            _arrow_image.image = [UIImage imageNamed:@"下拉"];
            
            numId = [roomID_arry objectAtIndex:num];
            [weakSealf requestQueryRoomByUserWithRoomId:numId];
            
        }];
    }
}

#pragma mark -- 查询机房信息按钮---
- (void)clickSeachBtn:(UIButton *)btn
{
    if (![DataUtility isBlankObject:numId]) {
     [self requestQueryRoomByUserWithRoomId:numId];
    }
   
    
}

#pragma mark -----refreshDelegate-------
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (headView == refreshView) {
        roomTimeCount = 1;
        [self requestQueryRoomByUserWithRoomId:numId];
    }else if (footView == refreshView){
        roomTimeCount ++;
        [self requestQueryRoomByUserWithRoomId:numId];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapSearch:(UITapGestureRecognizer *)tap
{
    imageView.animationImages = @[[UIImage imageNamed:@"search-1"],
                                  [UIImage imageNamed:@"search-2"],
                                  [UIImage imageNamed:@"search-3"],
                                  [UIImage imageNamed:@"search-4"]];
    imageView.animationDuration = 0.6;
    imageView.animationRepeatCount = 0;
    if (!imageView.isAnimating) {
        [imageView startAnimating];
        [searchBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    [self performSelector:@selector(stopButtonAnimation) withObject:nil afterDelay:1.0];
    if ([startField.text isEqualToString:@"请选择开始时间"]) {
        [SVProgressHUD showInfoWithStatus:@"请选择开始时间"];
        return;
    }else if([endField.text isEqualToString:@"请选择结束时间"]){
        [SVProgressHUD showInfoWithStatus:@"请选择结束时间"];
        return;
    }else{
//        [_filterData removeAllObjects];
//        [self requestQueryOpenLockhStartTime:startField.text WithEndTime:endField.text];
        
    }
}

- (void)stopButtonAnimation
{
    if ([imageView isAnimating]) {
        [imageView stopAnimating];
        [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    }
}

- (void)rebackToRootViewAction
{
    [self.navigationController popViewControllerAnimated:YES];
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

- (UIView *)tableViewHeader
{
    CGFloat ImageWith = (SCREEN_WIDTH-36-48)/2;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 118)];
    backView.backgroundColor = HexRGB(0xeeeeee);
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, SCREEN_WIDTH-36, 29)];
    title_lbl.text = @"授权机房";
    title_lbl.font = Font(12);
    title_lbl.textColor = HexRGB(0x999999);
    [backView addSubview:title_lbl];
    
    UIView *seachrView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 89)];
    seachrView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:seachrView];
    
    roomNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [roomNameBtn setBackgroundImage:[UIImage imageNamed:@"搜索选择时间"] forState:UIControlStateNormal];
     [roomNameBtn setTitle:@"暂无机房信息" forState:UIControlStateNormal];
    roomNameBtn.titleLabel.font = Font(12);
    [roomNameBtn setTitleColor:HexRGB(0x333333) forState:UIControlStateNormal];
    [roomNameBtn addTarget:self action:@selector(selectRoomBtn:) forControlEvents:UIControlEventTouchUpInside];
    [seachrView addSubview:roomNameBtn];
    
    UIView *seperateView = [[UIView alloc]init];
    seperateView.backgroundColor = HexRGB(0xececec);
    [seachrView addSubview:seperateView];
    
    
    UIImageView *startImage = [[UIImageView alloc]init];
    startImage.image = [UIImage imageNamed:@"搜索选择时间"];
    startImage.userInteractionEnabled = YES;
    [seachrView addSubview:startImage];
    
    startField = [[UITextField alloc]init];
    startField.placeholder = @"请选择开始时间";
    startField.delegate = self;
    startField.font = Font(14);
    startField.textColor = HexRGB(0x999999);
    startField.textAlignment = NSTextAlignmentCenter;
    [startImage addSubview:startField];
    
    UIImageView *endImage = [[UIImageView alloc]init];
    endImage.image = [UIImage imageNamed:@"搜索选择时间"];
    endImage.userInteractionEnabled = YES;
    [seachrView addSubview:endImage];
    
    endField = [[UITextField alloc]init];
    endField.placeholder = @"请选择结束时间";
    endField.delegate = self;
    endField.font = Font(14);
    endField.textColor = HexRGB(0x999999);
    endField.textAlignment = NSTextAlignmentCenter;
    [endImage addSubview:endField];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    
    [seachrView addSubview:searchBtn];
    
    imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    [searchBtn addSubview:imageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapSearch:)];
    [imageView addGestureRecognizer:tap];
    
    [roomNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(seachrView.mas_left).offset(18);
        make.top.equalTo(seachrView.mas_top).offset(5);
        make.width.mas_equalTo(ImageWith);
    }];
    
    [seperateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seachrView.mas_left).offset(18);
        make.right.equalTo(seachrView.mas_right).offset(18);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(roomNameBtn.mas_bottom).offset(5);
    }];
    
    [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seachrView.mas_left).offset(18);
        make.top.equalTo(seperateView.mas_bottom).offset(5);
        make.width.mas_equalTo(ImageWith);
    }];
    
    [startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(startImage);
    }];
    
    [endImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startImage.mas_right).offset(15);
        make.top.equalTo(seperateView.mas_bottom).offset(5);
        make.width.mas_equalTo(ImageWith);
    }];
    
    [endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(endImage);
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(seachrView.mas_right).offset(-10);
        make.centerY.equalTo(endField.mas_centerY);
        make.width.height.mas_equalTo(35);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(searchBtn);
    }];
    
    return backView;
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
