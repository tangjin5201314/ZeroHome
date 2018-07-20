//
//  LockRecordViewController.m
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//


#import "LockRecordViewController.h"
#import "MessageListCell.h"
#import "OpenLockModel.h"
#import "MJExtension.h"
#import "MHDatePicker.h"

@interface LockRecordViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *lockListArray;
@property (nonatomic,strong)NSMutableArray *filterData;
@property (nonatomic,strong)NSMutableArray *DataSouceArray;
@property (nonatomic,strong)UIView *tableViewHeader;
@property (nonatomic,strong)UITableView *maintableView;
@property (nonatomic ,strong)UISearchController *searchVC;
@property (strong, nonatomic) MHDatePicker *startPicker;
@property (strong, nonatomic) MHDatePicker *endDatePicker;
@end

@implementation LockRecordViewController
{
     int lockRecordCount;
//    UISearchDisplayController *searchDisplayController;
    NSString *searchString;
     MJRefreshHeaderView *headView;
    MJRefreshFooterView *footView;
    UITextField *startField;
    UITextField *endField;
    UIImageView *imageView; /*添加到搜索按钮上的动画图片*/
    UIButton *searchBtn;
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    
    self.title_lbl.text = @"开锁记录";
}

- (void)creatTableView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _maintableView.backgroundColor = HexRGB(0xeeeeee);
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    [_maintableView setTableFooterView:[UIView new]];
    [_maintableView setTableHeaderView:self.tableViewHeader];
    [self.view addSubview:_maintableView];
    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_maintableView];
    footView = [[MJRefreshFooterView alloc]initWithScrollView:_maintableView];
    headView.delegate = self;
    footView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     _filterData = [[NSMutableArray alloc]initWithCapacity:0];
    _lockListArray = [[NSMutableArray alloc]initWithCapacity:0];
    _DataSouceArray = [[NSMutableArray alloc]initWithCapacity:0];
    lockRecordCount = 1;
    [self creatNavigation];
    [self creatTableView];
    [self requestQueryOpenLock];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取机房开锁记录
- (void)requestQueryOpenLock
{
    startField.text = @"请选择开始时间";
    endField.text = @"请选择结束时间";
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryOpenHis];
    NSDictionary *parameters = @{@"lock_no":_lock_no,@"startTime":@"",@"endTime":@"",@"token":usertoken,@"pageNum":[NSNumber numberWithInt:lockRecordCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"开锁记录字典==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"机房开锁记录==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (lockRecordCount == 1) {
                [_lockListArray removeAllObjects];
            }
            if(lockRecordCount > [jsonObj[@"message"][@"openLockHis"][@"data"][@"total_page"] intValue]){
                if([footView isRefreshing]){
                    [footView endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headView isRefreshing])
                {
                    [headView endRefreshing];
                }
                return ;
            }
            
            NSArray *lockListArray = jsonObj[@"message"][@"openLockHis"][@"data"][@"rows"];
            for(NSDictionary *dic in lockListArray)
            {
                OpenLockModel *model = [OpenLockModel mj_objectWithKeyValues:dic];
                [_lockListArray addObject:model];
            }
            _DataSouceArray = _lockListArray;
            [_filterData removeAllObjects];
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


#pragma mark -机房开锁记录搜索--
- (void)requestQueryOpenLockhStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    
    NSString *startNum = [self stringConversionDateTime:startTime];
    NSString *endNum = [self stringConversionDateTime:endTime];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryOpenHis];
    NSDictionary *parameters = @{@"lock_no":_lock_no,@"startTime":startNum,@"endTime":endNum,@"token":usertoken,@"pageNum":[NSNumber numberWithInt:lockRecordCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"机房开锁记录搜索==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"机房开锁记录搜索==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSArray *lockListArray = jsonObj[@"message"][@"openLockHis"][@"data"][@"rows"];
            if (lockListArray.count==0) {
                [SVProgressHUD showInfoWithStatus:@"没有相关结果！"];
            }
            if(lockRecordCount > [jsonObj[@"message"][@"openLockHis"][@"data"][@"total_page"] intValue]){
                if([footView isRefreshing]){
                    [footView endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }
                return ;
            }

            for(NSDictionary *dic in lockListArray)
            {
                OpenLockModel *model = [OpenLockModel mj_objectWithKeyValues:dic];
                [_filterData addObject:model];
            }
            _DataSouceArray = _filterData;
            [_maintableView reloadData];
            
            if([footView isRefreshing]){
                [footView endRefreshing];
            }
        }else{
            NSString *message = jsonObj[@"message"][@"openLockHis"][@"rlt_msg"];
            [SVProgressHUD showInfoWithStatus:message];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        if([footView isRefreshing]){
            [footView endRefreshing];
        }
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark -----tableViewDelegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _DataSouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"MessageListCell";
    MessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MessageListCell" owner:self options:nil][0] ;
    }
        OpenLockModel *model = [_DataSouceArray objectAtIndex:indexPath.row];
        cell.lockModel = model;
    
    return cell;

}

- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
}

- (UIView *)tableViewHeader
{
    CGFloat ImageWith = (SCREEN_WIDTH-36-48)/2;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 75)];
    backView.backgroundColor = HexRGB(0xeeeeee);
    
    UIView *seachrView = [[UIView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 55)];
    seachrView.backgroundColor = [UIColor whiteColor];
    [backView addSubview:seachrView];
    
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
    
    [startImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(seachrView.mas_left).offset(18);
        make.centerY.equalTo(seachrView.mas_centerY);
        make.width.mas_equalTo(ImageWith);
    }];
    
    [startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(startImage);
    }];
    
    [endImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startImage.mas_right).offset(15);
        make.centerY.equalTo(seachrView.mas_centerY);
        make.width.mas_equalTo(ImageWith);
    }];
    
    [endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(endImage);
    }];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(seachrView.mas_right).offset(-10);
        make.centerY.equalTo(seachrView.mas_centerY);
        make.width.height.mas_equalTo(35);
    }];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(searchBtn);
    }];

    return backView;
}


//字符串转时间戳
- (NSString *)stringConversionDateTime:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];//创建一个日期格式化器
    dateFormatter.dateFormat=@"yyyy-MM-dd";//指定转date得日期格式化形式
    //    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/shanghai"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    
    NSTimeInterval a=[date timeIntervalSince1970]*1000; // *1000 是精确到毫秒，不乘就是精确到秒
    
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a]; //转为字符型
    //   NSInteger dateInt = [timeString integerValue];
    return timeString;
}

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
        [_filterData removeAllObjects];
        [self requestQueryOpenLockhStartTime:startField.text WithEndTime:endField.text];
        
    }
}

- (void)stopButtonAnimation
{
    if ([imageView isAnimating]) {
        [imageView stopAnimating];
        [searchBtn setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    }
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if(headView == refreshView){
        lockRecordCount = 1;
        [self requestQueryOpenLock];
    }else if (footView == refreshView){
        lockRecordCount++;
        if (_filterData.count>0) {
        [self requestQueryOpenLockhStartTime:startField.text WithEndTime:endField.text];
        }else{
            [self requestQueryOpenLock];
        }
       
    }
    
}

#pragma mark ------back-----
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [headView free];
    [footView free];
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
