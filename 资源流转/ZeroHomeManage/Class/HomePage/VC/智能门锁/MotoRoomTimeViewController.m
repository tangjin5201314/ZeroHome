//
//  MotoRoomTimeViewController.m
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "MotoRoomTimeViewController.h"
#import "OutSiderAuthorizeTimeCell.h"
#import "AutheTimeListModel.h"
#import "MJExtension.h"

@interface MotoRoomTimeViewController ()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic,strong)UITableView *maintableView;
@property (nonatomic,strong)NSMutableArray *dataSouceArray;
@end

@implementation MotoRoomTimeViewController
{
    int roomTimeCount;
    MJRefreshHeaderView *headView;
    MJRefreshFooterView *footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataSouceArray = [[NSMutableArray alloc]initWithCapacity:0];
    roomTimeCount = 1;
    [self creatTabaleView];
    [self  creatNavigation];
    [self requestQueryUserbyTelWithRoomId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    
    self.title_lbl.text = @"机房授权时限";
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
    [self.view addSubview:_maintableView];
    
    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_maintableView];
    footView = [[MJRefreshFooterView alloc]initWithScrollView:_maintableView];
    headView.delegate = self;
    footView.delegate = self;
    
}

#pragma mark - 获取机房时限列表
- (void)requestQueryUserbyTelWithRoomId
{
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *phoneNum = [ud objectForKey:@"iphoneNumber"];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KAllUserlockByTel];
    
    NSDictionary *parameters = @{@"token":usertoken,@"tel":phoneNum,@"roomId":_roomId,@"pageNum":[NSNumber numberWithInt:roomTimeCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"机房时限列表==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (roomTimeCount == 1) {
                [_dataSouceArray removeAllObjects];
            }
            if (roomTimeCount>[jsonObj[@"message"][@"UserLockVOs"][@"total"]intValue]) {
                if([footView isRefreshing]){
                    [footView endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headView isRefreshing])
                {
                    [headView endRefreshing];
                }
                return ;
            }
            NSArray *listArray = jsonObj[@"message"][@"UserLockVOs"][@"list"];
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


#pragma mark ----tableViewDelegate-----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSouceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutSiderAuthorizeTimeCell *cell = (OutSiderAuthorizeTimeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"OutSiderAuthorizeTimeCell";
    OutSiderAuthorizeTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"OutSiderAuthorizeTimeCell" owner:self options:nil][0] ;
    }
    AutheTimeListModel *model = [_dataSouceArray objectAtIndex:indexPath.row];
    cell.listModel = model;
    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
    if ([model.endTime doubleValue]<[startTime doubleValue]) {
        cell.backgroundColor = HexRGB(0xf6f6f6);
        cell.start_lbl.textColor = HexRGB(0x999999);
        cell.end_lbl.textColor = HexRGB(0x999999);
        cell.startDate_lbl.textColor = HexRGB(0x999999);
        cell.startTime_lbl.textColor = HexRGB(0x999999);
        cell.endDate_lbl.textColor = HexRGB(0x999999);
        cell.endTime_lbl.textColor = HexRGB(0x999999);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *section_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 29)];
    section_view.backgroundColor = HexRGB(0xeeeeee);
    
    UILabel *section_lbl = [[UILabel alloc]initWithFrame:CGRectMake(18, 0, 100, section_view.height)];
    section_lbl.font = Font(12);
    section_lbl.textColor = HexRGB(0x999999);
    [section_view addSubview:section_lbl];
    section_lbl.text = _motoRoomName;
    return section_view;
}


#pragma mark ------back-----
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (headView == refreshView) {
        roomTimeCount = 1;
        [self requestQueryUserbyTelWithRoomId];
    }else if (footView == refreshView){
        roomTimeCount ++;
        [self requestQueryUserbyTelWithRoomId];
    }
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
