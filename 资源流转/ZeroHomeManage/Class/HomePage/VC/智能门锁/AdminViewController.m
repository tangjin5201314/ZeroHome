//
//  AdminViewController.m
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//


#import "AdminViewController.h"
#import "AdminModel.h"
#import "MJExtension.h"
#import "AdminAuthouTableViewCell.h"
#import "customTableView.h"
#import "LHTopTextView.h"
#import "LHEditTextView.h"
@interface AdminViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MYTableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate,adminAuthouSendPawordDelegate>
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)customTableView *maintableView;
@property (nonatomic,strong)NSMutableArray *dataSouceArray;  //全部
@property (nonatomic,strong)NSMutableArray *dataUnAuthArray; //未授权
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UISearchBar *searchBar;
//@property (nonatomic ,strong)UISearchDisplayController *searchDC;
@property (nonatomic,readwrite)NSIndexPath *index;
@end

@implementation AdminViewController
{
    int adminCount;   //全部
    int unAuthCount;  //未授权
    MJRefreshHeaderView *headview;
    MJRefreshFooterView *footview;
    UITableViewRowAction *agreeAction;
    UIButton *unAuthBtn;
    UIButton *allBtn;
    UIImageView *seperaView; //分割线
    BOOL isSearch; //是否是搜索
    NSString *searchStr;
    UITextField *refuseReason_field;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSearch = NO;
    _dataSouceArray = [[NSMutableArray alloc]init];
    _dataUnAuthArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    adminCount = 1;
    unAuthCount = 1;
    [self creatNavigation];
    [self creatTableView];
    [self requestqueryAllUnAuthUserLockWithName:@""];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    self.title_lbl.text = @"授权审核";

    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];

}

- (void)creatTableView
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    unAuthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unAuthBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 40);
    [unAuthBtn setTitle:@"未审核" forState:UIControlStateNormal];
    unAuthBtn.titleLabel.font = Font(15);
    [unAuthBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
    [unAuthBtn addTarget:self action:@selector(clickUnAuthBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:unAuthBtn];
    
    allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    allBtn.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 40);
    [allBtn setTitle:@"全部" forState:UIControlStateNormal];
    allBtn.titleLabel.font = Font(15);
    [allBtn setTitleColor:HexRGB(0x2e2e2e) forState:UIControlStateNormal];
    [allBtn addTarget:self action:@selector(clickAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:allBtn];
    
//    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(unAuthBtn.frame), 5, 1, 30)];
//    centerView.backgroundColor = HexRGB(0xeeeeee);
//    [titleView addSubview:centerView];
    
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, unAuthBtn.bottom-1, SCREEN_WIDTH, 0.5)];
    bottomView.backgroundColor = HexRGB(0xeeeeee);
    [titleView addSubview:bottomView];
    
    seperaView = [[UIImageView alloc]initWithFrame:CGRectMake(0,unAuthBtn.bottom-1 ,unAuthBtn.width , 1)];
    seperaView.image = [UIImage imageNamed:@"blue.png"];
    [titleView addSubview:seperaView];
    
    _backScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    _backScrollView.delegate = self;
    _backScrollView.pagingEnabled = YES;
    _backScrollView.backgroundColor = [UIColor whiteColor];
//    _backScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _backScrollView.height);
    _backScrollView.contentSize = CGSizeMake(0, _backScrollView.height);
    [self.view addSubview:_backScrollView];

    for(int i =0;i<2;i++)
    {
        _maintableView = [[customTableView alloc]initWithCustomFrame:CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, _backScrollView.height) Style:UITableViewStylePlain myself:self];
        _maintableView.backgroundColor = HexRGB(0xeeeeee);
        _maintableView.tag = i+2000;
        _maintableView.RefreshDelegate = self;
        _maintableView.headRefresh = YES;
        _maintableView.footRefresh = YES;
        [_maintableView setTableFooterView:[UIView new]];
        _maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_backScrollView addSubview:_maintableView];
        
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50.0);
        _searchBar.placeholder = @"请输入姓名";
        _searchBar.delegate = self;
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.backgroundColor = [UIColor whiteColor];
        _maintableView.tableHeaderView = _searchBar;
        
        UIView *subView = [_searchBar.subviews firstObject];
        for (UIView *tmpView in subView.subviews) {
            if ([tmpView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [tmpView removeFromSuperview];
            }
            if ([tmpView isKindOfClass:[UITextField class]]) {
                tmpView.layer.masksToBounds = YES;
                tmpView.layer.cornerRadius = 3;
                tmpView.layer.borderWidth = 0.5;
                tmpView.layer.borderColor = HexRGB(0xD8D8D8).CGColor;
                tmpView.backgroundColor = HexRGB(0xeeeff3);
            }
        }


        [_maintableView registerNib:[UINib nibWithNibName:@"AdminAuthouTableViewCell" bundle:nil] forCellReuseIdentifier:@"AdminAuthouTableViewCell"];
    }
    
}


#pragma mark - 获取所有审核列表
- (void)requestqueryAllUserLockWithName:(NSString *)name
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,@"/lock/queryAllUserLock"];
    
    NSDictionary *parameters = @{@"token":usertoken,@"name":name,@"pageNum":[NSNumber numberWithInt:adminCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"所有审核列表==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"所有审核列表==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (adminCount == 1) {
                [_dataSouceArray removeAllObjects];
            }
            if (adminCount>[jsonObj[@"message"][@"userLockList"][@"pages"]intValue]) {
                if([footview isRefreshing]){
                    [footview endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headview isRefreshing])
                {
                    [headview endRefreshing];
                }
                return ;
            }
        NSArray *checkOrderArray = jsonObj[@"message"][@"userLockList"][@"list"];
            for(NSDictionary *dic in checkOrderArray)
            {
                AdminModel *model = [AdminModel mj_objectWithKeyValues:dic];
                [_dataSouceArray addObject:model];
            }
            _dataArray = _dataSouceArray;
            UITableView *customTable = [_backScrollView viewWithTag:2001];
            [customTable reloadData];
        }
        if([footview isRefreshing]){
            [footview endRefreshing];
        }else if ([headview isRefreshing])
        {
            [headview endRefreshing];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        if([footview isRefreshing]){
            [footview endRefreshing];
        }else if ([headview isRefreshing])
        {
            [headview endRefreshing];
        }
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark - 获取未审核列表
- (void)requestqueryAllUnAuthUserLockWithName:(NSString *)name
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,@"/lock/queryAllUserLockCheck"];
    
    NSDictionary *parameters = @{@"token":usertoken,@"name":name,@"pageNum":[NSNumber numberWithInt:unAuthCount],@"pageSize":[NSNumber numberWithInt:10]};
    NSLog(@"xxxxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"获取未审核列表==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (unAuthCount == 1) {
                [_dataUnAuthArray removeAllObjects];
            }
            if ([jsonObj[@"message"][@"userLockList"][@"pages"]intValue]==0) {
              [SVProgressHUD showInfoWithStatus:@"暂无未授权的信息"];
                UITableView *customTable = [_backScrollView viewWithTag:2000];
                [customTable reloadData];
            }
            if (unAuthCount>[jsonObj[@"message"][@"userLockList"][@"pages"]intValue]) {
                if([footview isRefreshing]){
                    [footview endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headview isRefreshing])
                {
                    [headview endRefreshing];
                }
                return ;
            }
            NSArray *checkOrderArray = jsonObj[@"message"][@"userLockList"][@"list"];

            for(NSDictionary *dic in checkOrderArray)
            {
                AdminModel *model = [AdminModel mj_objectWithKeyValues:dic];
                [_dataUnAuthArray addObject:model];
            }
            
            _dataArray = _dataUnAuthArray;
            UITableView *customTable = [_backScrollView viewWithTag:2000];
            [customTable reloadData];
        }
        if([footview isRefreshing]){
            [footview endRefreshing];
        }else if ([headview isRefreshing])
        {
            [headview endRefreshing];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        if([footview isRefreshing]){
            [footview endRefreshing];
        }else if ([headview isRefreshing])
        {
            [headview endRefreshing];
        }
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark -- 给用户授权接口------
- (void)requestUpdateUserLockWith:(AdminModel *)model AndcheckOrder:(NSString *)checker Reason:(NSString *)reason
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,@"/lock/updateUserLock"];
    NSDictionary *parameters = @{@"token":usertoken,@"id":@(model.ID),@"checkOrder":checker,@"failReason":reason,@"adminName":realName};
    NSLog(@"hhhhhh==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"给用户授权==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){

        }
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark -- 发送密码
- (void)requestSendPassWordWith:(AdminModel *)model
{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,@"/lock/sendPassword"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
    
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:[model.startTime doubleValue]/1000];
    NSString *startDateStr = [dateFormatter stringFromDate: startdate];
    
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[model.endTime doubleValue] / 1000];
    NSString *endDateStr = [dateFormatter stringFromDate: endDate];
    
    NSDate *dateStart = [dateFormatter dateFromString:startDateStr];
    long long timeStart = [[NSNumber numberWithDouble:[dateStart timeIntervalSince1970]] longLongValue];
    timeStart = [[NSString stringWithFormat:@"%ld000",(long)timeStart] longLongValue];
    
    NSDate *dateEnd = [dateFormatter dateFromString:endDateStr];
    long long timeEnd = [[NSNumber numberWithDouble:[dateEnd timeIntervalSince1970]] longLongValue];
    timeEnd = timeEnd+3600;
    timeEnd = [[NSString stringWithFormat:@"%ld000",(long)timeEnd] longLongValue];
    
    
    NSDictionary *parameters = @{@"token":usertoken,@"adminId":@(model.ID),@"adminName":realName,@"realName":model.realName,@"lock_no":model.lock_no,@"tel":model.tel,@"passType":[NSNumber numberWithInt:2],@"sTime":[NSNumber numberWithDouble:timeStart],@"eTime":[NSNumber numberWithDouble:timeEnd]};
    NSLog(@"%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"发送密码--->>%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            [SVProgressHUD showInfoWithStatus:@"密码下发成功,请注意查收"];
        }else{
            [SVProgressHUD showInfoWithStatus:[jsonObj objectForKey:@"reason"]];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark -----tableViewDelegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (tableView.tag == 2000) {
       UITableView *customTable = [_backScrollView viewWithTag:2000];
      return [customTable cellHeightForIndexPath:indexPath model:model keyPath:@"adminModel" cellClass:[AdminAuthouTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }else {
        UITableView *customTable = [_backScrollView viewWithTag:2001];
        return [customTable cellHeightForIndexPath:indexPath model:model keyPath:@"adminModel" cellClass:[AdminAuthouTableViewCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminAuthouTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AdminAuthouTableViewCell"];
    AdminModel *model = [_dataArray objectAtIndex:indexPath.row];

    cell.adminModel = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.http getLinkStatus:^(NSInteger linkStatus) {
        switch (linkStatus) {
            case 0:
                [SVProgressHUD showInfoWithStatus:@"网络无连接,请打开网络设置"];
                break;
            default:
                break;
        }
    }];
    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
    
    AdminModel *model = [_dataArray objectAtIndex:indexPath.row];
    _index = indexPath;
    __weak typeof(self)weakSealf = self;
    UITableViewRowAction *refuseAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"拒绝" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       
        if ([model.endTime doubleValue]<[startTime doubleValue]) {
            [SVProgressHUD showInfoWithStatus:@"操作失败,时间已过期！"];
            return ;
        }
        if (model.checkOrder == 2) {
            if (model.openType == 2) {
                NSString *message = [NSString stringWithFormat:@"是否要给%@发送%@机房的密码",model.realName,model.room_name];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                                         message:@""
                                                                                  preferredStyle:UIAlertControllerStyleAlert ];
                
                //添加取消到UIAlertController中
                [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                //添加确定到UIAlertController中
                [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [weakSealf requestSendPassWordWith:model];
                    [weakSealf requestUpdateUserLockWith:model AndcheckOrder:@"1" Reason:@""];
                    model.checkOrder = 1;
                    agreeAction.title = @"取消授权";
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }else
            {
                [weakSealf requestUpdateUserLockWith:model AndcheckOrder:@"1" Reason:@""];
                agreeAction.title = @"取消授权";
                model.checkOrder = 1;
            }

        }else if (model.checkOrder == 4||model.checkOrder == 1){
            LHTopTextView *topTextView=[[LHTopTextView alloc]initWithFrame:CGRectMake(18, SCREEN_HEIGHT/3, SCREEN_WIDTH-36, 161)];
            topTextView.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64-161)/2);
            [tableView addSubview:topTextView];
            __weak typeof(topTextView)weakTopText = topTextView;
            topTextView.closeBlock = ^{
                weakTopText.hidden = YES;
                [weakSealf.view endEditing:YES];
            };
            topTextView.submitBlock = ^(NSString *reasonStr){
                weakTopText.hidden = YES;
                [weakSealf.view endEditing:YES];
                if ([reasonStr isEqualToString:@"请您输入您拒绝的原因"]) {
                    [SVProgressHUD showInfoWithStatus:@"拒绝原因不能为空"];
                }else{
                    [weakSealf requestUpdateUserLockWith:model AndcheckOrder:@"2" Reason:reasonStr];
                    model.checkOrder = 2;
//                   [tableView reloadData]; 
                }
            };
          }
        
        [tableView reloadData];
//        tableView.editing = NO;
        
    }];
    
   agreeAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"同意" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
       if (model.checkOrder == 1) {

           if ([model.endTime doubleValue]<[startTime doubleValue]) {
               [SVProgressHUD showInfoWithStatus:@"取消失败,时间已过期！"];
               return ;
           }

          [weakSealf requestUpdateUserLockWith:model AndcheckOrder:@"4" Reason:@""];
            agreeAction.title = @"同意";
            model.checkOrder = 4;
           model.openType = 1;
       }else if (model.checkOrder == 4)
       {
           if ([model.endTime doubleValue]<[startTime doubleValue]) {
               [SVProgressHUD showInfoWithStatus:@"操作失败,时间已过期！"];
               return ;
           }

           if (model.openType == 2) {
            NSString *message = [NSString stringWithFormat:@"是否要给%@发送%@机房的密码",model.realName,model.room_name];
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                                        message:@""
                                                                                 preferredStyle:UIAlertControllerStyleAlert ];
               
               //添加取消到UIAlertController中
               [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                   
               }]];
               
               //添加确定到UIAlertController中
               [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                   [weakSealf requestSendPassWordWith:model];
                   [weakSealf requestUpdateUserLockWith:model AndcheckOrder:@"1" Reason:@""];
                   model.checkOrder = 1;
                   agreeAction.title = @"取消授权";
               }]];
               [self presentViewController:alertController animated:YES completion:nil];
           }else{
               [weakSealf requestUpdateUserLockWith:model AndcheckOrder:@"1" Reason:@""];
               agreeAction.title = @"取消授权";
               model.checkOrder = 1;
           }
       }
       [tableView reloadData];
       tableView.editing = NO;
    }];
    if (model.checkOrder == 1 ) {
        agreeAction.title = @"取消授权";
    }else if (model.checkOrder == 2){
        refuseAction.title = @"授权";
    }
    agreeAction.backgroundColor = HexRGB(0x4facf6);
     NSArray *arr = @[agreeAction, refuseAction];
    if (model.checkOrder == 2) {
        return @[refuseAction];
    }else{
      return arr;
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [LHEditTextView showWithController:self andRequestDataBlock:^(NSString *text) {
        NSLog(@"显示成功");
    }];
}

#pragma mark -- adminAuthouSendPawordDelegate
- (void)adminAuthouSendPassWordBtn:(AdminAuthouTableViewCell *)adminCell
{
    AdminModel *model = adminCell.adminModel;
    NSString *message = [NSString stringWithFormat:@"是否要给%@发送%@机房的密码",model.realName,model.room_name];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                             message:@""
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    //添加确定到UIAlertController中
    [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self requestSendPassWordWith:model];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark ----- UISearchBarDelegate------------
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
     searchStr = searchText;
     isSearch = YES;
    int indexNum = _backScrollView.contentOffset.x/SCREEN_WIDTH;
    if(indexNum == 0){
        [_dataUnAuthArray removeAllObjects];
        [self requestqueryAllUnAuthUserLockWithName:searchText];
    }
    else{
        [_dataSouceArray removeAllObjects];
        [self requestqueryAllUserLockWithName:searchText];
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}

- (void)clickUnAuthBtn:(UIButton *)btn
{
//     [_dataArray removeAllObjects];
    if(_dataUnAuthArray.count == 0){
        unAuthCount = 1;
        [self requestqueryAllUnAuthUserLockWithName:@""];
    }else{
        _dataArray = _dataUnAuthArray;
        
        UITableView *tableV = [_backScrollView viewWithTag:2000];
        [tableV reloadData];
    }

    [unAuthBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
    [allBtn setTitleColor:HexRGB(0x2e2e2e) forState:UIControlStateNormal];
    
    
        [UIView animateWithDuration:.3 animations:^{
            seperaView.center = CGPointMake(btn.center.x, seperaView.center.y);
            _backScrollView.contentOffset = CGPointMake(0, 0);
        }];
}

- (void)clickAllBtn:(UIButton *)btn
{
//    [_dataArray removeAllObjects];
    [allBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
    [unAuthBtn setTitleColor:HexRGB(0x2e2e2e) forState:UIControlStateNormal];
    
    if(_dataSouceArray.count == 0){
        adminCount = 1;
        [self requestqueryAllUserLockWithName:@""];
    }else{
        _dataArray = _dataSouceArray;
        
        UITableView *tableV = [_backScrollView viewWithTag:2001];
        [tableV reloadData];
    }

    [UIView animateWithDuration:.3 animations:^{
        seperaView.center = CGPointMake(btn.center.x, seperaView .center.y);
        _backScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }];

}

#pragma mark - refresh
-(void)refHeadView:(MJRefreshHeaderView *)headView{
    [self.view endEditing:YES];
    headview = headView;
    int indexNum = _backScrollView.contentOffset.x/SCREEN_WIDTH;
    if(indexNum == 0){
        UITableView *tableView = [_backScrollView viewWithTag:2000];
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50.0);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名";
        _searchBar.backgroundColor = [UIColor whiteColor];
        tableView.tableHeaderView = _searchBar;
        UIView *subView = [_searchBar.subviews firstObject];
        for (UIView *tmpView in subView.subviews) {
            if ([tmpView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [tmpView removeFromSuperview];
            }
            if ([tmpView isKindOfClass:[UITextField class]]) {
                tmpView.layer.masksToBounds = YES;
                tmpView.layer.cornerRadius = 3;
                tmpView.layer.borderWidth = 0.5;
                tmpView.layer.borderColor = HexRGB(0xD8D8D8).CGColor;
                tmpView.backgroundColor = HexRGB(0xeeeff3);
            }
        }

        unAuthCount =1;
        [self requestqueryAllUnAuthUserLockWithName:@""];
    }
    else{
        UITableView *tableView = [_backScrollView viewWithTag:2001];
        _searchBar = [[UISearchBar alloc]init];
        _searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 50.0);
        _searchBar.delegate = self;
        _searchBar.placeholder = @"请输入姓名";
        _searchBar.backgroundColor = [UIColor whiteColor];
        tableView.tableHeaderView = _searchBar;
        UIView *subView = [_searchBar.subviews firstObject];
        for (UIView *tmpView in subView.subviews) {
            if ([tmpView isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [tmpView removeFromSuperview];
            }
            if ([tmpView isKindOfClass:[UITextField class]]) {
                tmpView.layer.masksToBounds = YES;
                tmpView.layer.cornerRadius = 3;
                tmpView.layer.borderWidth = 0.5;
                tmpView.layer.borderColor = HexRGB(0xD8D8D8).CGColor;
                tmpView.backgroundColor = HexRGB(0xeeeff3);
            }
        }

        adminCount = 1;
        [self requestqueryAllUserLockWithName:@""];
    }
}

-(void)refFootView:(MJRefreshFooterView *)footView{
    footview = footView;
    int indexNum = _backScrollView.contentOffset.x/SCREEN_WIDTH;
    if(indexNum == 0){
        unAuthCount ++;
        if (isSearch) {
        [self requestqueryAllUnAuthUserLockWithName:searchStr];
        }else{
           [self requestqueryAllUnAuthUserLockWithName:@""];
        }
    }else{
        adminCount++;
        if (isSearch) {
            [self requestqueryAllUserLockWithName:searchStr];
        }else{
            [self requestqueryAllUserLockWithName:@""];
        }
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
     AdminModel *model = [_dataArray objectAtIndex:_index.row];
    int indexNum = _backScrollView.contentOffset.x/SCREEN_WIDTH;
   
    if (buttonIndex == 1) {
        UITableView *tableView;
        if (indexNum == 0) {
           tableView = [_backScrollView viewWithTag:2000];
        }else{
           tableView = [_backScrollView viewWithTag:2001];
        }
        if ([refuseReason_field.text isEqualToString:@""]) {
            [SVProgressHUD showInfoWithStatus:@"拒绝原因不能为空"];
        }else{
            [self requestUpdateUserLockWith:model AndcheckOrder:@"2" Reason:refuseReason_field.text];
            model.checkOrder = 2;
            [tableView reloadData];
        }
      
    }
}

#pragma mark ------back-----
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    for(customTableView *tableview in _backScrollView.subviews){
        if([tableview isKindOfClass:[customTableView class]]){
            [tableview Todealloc];
        }
    }
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
