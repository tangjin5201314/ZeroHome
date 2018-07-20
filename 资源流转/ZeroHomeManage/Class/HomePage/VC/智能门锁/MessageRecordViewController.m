//
//  MessageRecordViewController.m
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "MessageRecordViewController.h"
#import "PushNewListCell.h"
#import "NewPushModel.h"
#import "MJExtension.h"
#import "MHDatePicker.h"
@interface MessageRecordViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIView *tableViewHeader;
@property (nonatomic,strong)UITableView *maintableView;
@property (nonatomic,strong)NSMutableArray *pushListArray;
@property (nonatomic,strong)NSMutableArray *filterData;
@property (nonatomic,strong)NSMutableArray *DataSouceArray;
@property (strong, nonatomic) MHDatePicker *startPicker;
@property (strong, nonatomic) MHDatePicker *endDatePicker;
@end

@implementation MessageRecordViewController
{
    MJRefreshHeaderView *headView;
    MJRefreshFooterView *footView;
    int newPushCount ;
    UITextField *startField;
    UITextField *endField;
    UIButton *searchBtn;
    UIImageView *imageView;
    
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    
    self.title_lbl.text = @"消息记录";
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
    [_maintableView setTableHeaderView:self.tableViewHeader];
    [_maintableView setTableFooterView:[UIView new]];
    [self.view addSubview:_maintableView];
    
    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_maintableView];
    footView = [[MJRefreshFooterView alloc]initWithScrollView:_maintableView];
    headView.delegate = self;
    footView.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pushListArray = [[NSMutableArray alloc]initWithCapacity:0];
    _DataSouceArray = [[NSMutableArray alloc]initWithCapacity:0];
    _filterData = [[NSMutableArray alloc]initWithCapacity:0];
     newPushCount = 1;
     [self creatNavigation];
     [self creatTableView];
    [self requestLockPushList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 获取消息推送记录
- (void)requestLockPushList
{
    startField.text = @"请选择开始时间";
    endField.text = @"请选择结束时间";
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KLockPushList];
    NSDictionary *parameters = @{@"lock_no":_lock_no,@"startTime":@"",@"endTime":@"",@"token":usertoken,@"pageNum":[NSNumber numberWithInt:newPushCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"消息字典：%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"消息推送记录==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (newPushCount == 1) {
                [_pushListArray removeAllObjects];
            }
            if (newPushCount>[jsonObj[@"message"][@"pushList"][@"total"]intValue]) {
                if([footView isRefreshing]){
                    [footView endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headView isRefreshing])
                {
                    [headView endRefreshing];
                }
                return ;
            }
            NSArray *pushListArray = jsonObj[@"message"][@"pushList"][@"list"];
            for(NSDictionary *dic in pushListArray)
            {
                NewPushModel *model = [NewPushModel mj_objectWithKeyValues:dic];
                [_pushListArray addObject:model];
            }
            _DataSouceArray = _pushListArray;
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

#pragma mark -机房开锁记录搜索---
- (void)requestQueryOpenLockhStartTime:(NSString *)startTime WithEndTime:(NSString *)endTime
{
    [_filterData removeAllObjects];
    NSString *startNum = [self stringConversionDateTime:startTime];
    NSString *endNum = [self stringConversionDateTime:endTime];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KLockPushList];
    NSDictionary *parameters = @{@"lock_no":_lock_no,@"startTime":startNum,@"endTime":endNum,@"token":usertoken,@"pageNum":[NSNumber numberWithInt:newPushCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"消息记录搜索==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"消息记录搜索==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            NSArray *lockListArray = jsonObj[@"message"][@"pushList"][@"list"];
            if (lockListArray.count==0) {
                [SVProgressHUD showInfoWithStatus:@"没有相关结果！"];
            }
            for(NSDictionary *dic in lockListArray)
            {
                NewPushModel *model = [NewPushModel mj_objectWithKeyValues:dic];
                [_filterData addObject:model];
            }
            _DataSouceArray = _filterData;
            [_maintableView reloadData];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark ----tableViewDelegate-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _DataSouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"PushNewListCell";
    PushNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PushNewListCell" owner:self options:nil][0] ;
    }
    NewPushModel *model = [_DataSouceArray objectAtIndex:indexPath.row];
    cell.pushModel = model;
    return cell;
    
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
//    [searchBtn addTarget:self action:@selector(clickSearch:) forControlEvents:UIControlEventTouchUpInside];
    [seachrView addSubview:searchBtn];
    
    imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
//    imageView.image = [UIImage imageNamed:@"搜索"];
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

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if(headView == refreshView){
        newPushCount = 1;
        [self requestLockPushList];
    }else if (footView == refreshView){
        newPushCount++;
        if (_filterData.count>0) {
            [self requestQueryOpenLockhStartTime:startField.text WithEndTime:endField.text];
        }else{
            [self requestLockPushList];
        }
    }
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


- (NSString *)dateStringWithDate:(NSDate *)date DateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    NSString *str = [dateFormatter stringFromDate:date];
    return str ? str : @"";
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
