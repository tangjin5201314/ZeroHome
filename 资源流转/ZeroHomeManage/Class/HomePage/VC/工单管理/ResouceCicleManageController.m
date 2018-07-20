//
//  ResouceCicleManageController.m
//  ZeroHomeManage
//
//  Created by cuco on 2018/4/17.
//  Copyright © 2018年 TW. All rights reserved.
//流转记录-资源

#import "ResouceCicleManageController.h"
#import "ResourceCirculationController.h"
#import "XYChooseTypeAlertView.h"
#import "customTableView.h"
#import "WorkAdminManageCell.h"
#import "AdminModel.h"
#import "MJExtension.h"

@interface ResouceCicleManageController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,WorkAdminManageDelegate,MYTableViewDelegate,XYChooseTypeAlertViewDelegate>
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)customTableView *maintableView;
@property (nonatomic,strong)NSMutableArray *dataSouceArray;  //全部
@property (nonatomic,strong)NSMutableArray *dataUnAuthArray; //未授权
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UISearchBar *searchBar;

@end

@implementation ResouceCicleManageController
{
    MJRefreshHeaderView *headview;
    MJRefreshFooterView *footview;
    int adminCount;   //全部
    int unAuthCount;  //未授权
    UIButton *unAuthBtn;
    UIButton *allBtn;
    UIImageView *seperaView; //分割线
    BOOL isSearch; //是否是搜索
    NSString *searchStr;
    NSInteger selectIndex; //选择的哪一行
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [unAuthBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
    [allBtn setTitleColor:HexRGB(0x2e2e2e) forState:UIControlStateNormal];
    [UIView animateWithDuration:.3 animations:^{
        seperaView.center = CGPointMake(unAuthBtn.center.x, seperaView.center.y);
        _backScrollView.contentOffset = CGPointMake(0, 0);
    }];
    unAuthCount = 1;
    [self requestqueryAllUnAuthUserLockWithName:@""];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    self.title_lbl.text = @"流转记录-资源";
    
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    
}

- (void)creatTableView
{
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 40)];
    titleView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleView];
    unAuthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unAuthBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 40);
    [unAuthBtn setTitle:@"未流转" forState:UIControlStateNormal];
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

    _backScrollView.contentSize = CGSizeMake(0, _backScrollView.height);
    [self.view addSubview:_backScrollView];
    
    for(int i =0;i<2;i++)
    {
        _maintableView = [[customTableView alloc]initWithCustomFrame:CGRectMake(SCREEN_WIDTH*i,0, SCREEN_WIDTH, _backScrollView.height) Style:UITableViewStylePlain myself:self];
        _maintableView.backgroundColor = HexRGB(0xeeeeee);
        _maintableView.tag = i+1000;
        _maintableView.RefreshDelegate = self;
        _maintableView.headRefresh = YES;
        _maintableView.footRefresh = YES;
        [_maintableView setTableFooterView:[UIView new]];
        _maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_backScrollView addSubview:_maintableView];
        
        [_maintableView registerNib:[UINib nibWithNibName:@"WorkAdminManageCell" bundle:nil] forCellReuseIdentifier:@"manageCell"];
        
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
    }
}

#pragma mark - 获取所有审核列表
- (void)requestqueryAllUserLockWithName:(NSString *)name
{
//    [self.dataSouceArray removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomOrderListByState];
    
    NSDictionary *parameters = @{@"token":usertoken,@"type":[NSNumber numberWithInteger:areaType],@"pageNum":[NSNumber numberWithInt:adminCount],@"pageSize":[NSNumber numberWithInt:10],@"workerName":name};
    NSLog(@"所有审核列表==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"所有审核列表==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (adminCount == 1) {
                [_dataSouceArray removeAllObjects];
            }
            if ([jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue]==0) {
                [SVProgressHUD showInfoWithStatus:@"暂无未授权的信息"];
                UITableView *customTable = [_backScrollView viewWithTag:1001];
                [self.dataArray removeAllObjects];
                [customTable reloadData];
            }
            if (adminCount>[jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue]) {
                if([footview isRefreshing]){
                    [footview endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headview isRefreshing])
                {
                    [headview endRefreshing];
                }
                return ;
            }
            NSArray *checkOrderArray = jsonObj[@"message"][@"roomOrderList"][@"list"];
            for(NSDictionary *dic in checkOrderArray)
            {
                AdminModel *model = [AdminModel mj_objectWithKeyValues:dic];
                [_dataSouceArray addObject:model];
            }
            _dataArray = _dataSouceArray;
            UITableView *customTable = [_backScrollView viewWithTag:1001];
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

#pragma mark - 获取未审核列表  //查询工单
- (void)requestqueryAllUnAuthUserLockWithName:(NSString *)name
{
//    [self.dataUnAuthArray removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomOrderListByState];
    
    NSDictionary *parameters = @{@"token":usertoken,@"type":[NSNumber numberWithInteger:areaType],@"pageNum":[NSNumber numberWithInt:unAuthCount],@"pageSize":[NSNumber numberWithInt:10],@"state":[NSNumber numberWithInt:1],@"workerName":name};
    NSLog(@"%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"xxxxx===%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (unAuthCount == 1) {
                [_dataUnAuthArray removeAllObjects];
            }
            if ([jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue]==0) {
                [SVProgressHUD showInfoWithStatus:@"暂无未授权的信息"];
                UITableView *customTable = [_backScrollView viewWithTag:1000];
                [self.dataArray removeAllObjects];
                [customTable reloadData];
            }
            if (unAuthCount>[jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue]) {
                if([footview isRefreshing]){
                    [footview endRefreshing];
                    [SVProgressHUD showInfoWithStatus:@"无更多内容"];
                }else if ([headview isRefreshing])
                {
                    [headview endRefreshing];
                }
                return ;
            }
            NSArray *checkOrderArray = jsonObj[@"message"][@"roomOrderList"][@"list"];
            
            for(NSDictionary *dic in checkOrderArray)
            {
                AdminModel *model = [AdminModel mj_objectWithKeyValues:dic];
                [_dataUnAuthArray addObject:model];
            }
            
            _dataArray = _dataUnAuthArray;
            UITableView *customTable = [_backScrollView viewWithTag:1000];
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
- (void)requestUpdateUserLockWith:(AdminModel *)model AndcheckOrdeState:(NSInteger )state
{
    int indexNum = _backScrollView.contentOffset.x/SCREEN_WIDTH;
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomUpdateWokeOrderFour];
    NSDictionary *parameters = @{@"token":usertoken,@"id":@(model.ID),@"state":[NSNumber numberWithInteger:state]};
    NSLog(@"hhhhhh==%@",parameters);
    __weak typeof (self)weakSeaf = self ;
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"给用户授权==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
//            [weakSeaf.maintableView reloadData];
            model.state = state;
            if (indexNum == 0) {
            [weakSeaf requestqueryAllUnAuthUserLockWithName:@""];
            }else{
            [weakSeaf requestqueryAllUserLockWithName:@""];
            }
            
            [SVProgressHUD showSuccessWithStatus:nil];
        }else{
            [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark -----tableViewDelegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataArray.count != 0) {
        AdminModel *model = [_dataArray objectAtIndex:indexPath.row];
        if (tableView.tag == 1000) {
            UITableView *customTable = [_backScrollView viewWithTag:1000];
            return [customTable cellHeightForIndexPath:indexPath model:model keyPath:@"adminModel" cellClass:[WorkAdminManageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
        }else {
            UITableView *customTable = [_backScrollView viewWithTag:1001];
            return [customTable cellHeightForIndexPath:indexPath model:model keyPath:@"adminModel" cellClass:[WorkAdminManageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
        }
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkAdminManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"manageCell"];
//    if (cell == nil) {
//        cell = [[NSBundle mainBundle]loadNibNamed:@"WorkAdminManageCell" owner:self options:nil][0] ;
//    }
    cell.delegate = self;
    AdminModel *model;
    if (self.dataArray.count>0) {
        model = [_dataArray objectAtIndex:indexPath.row];
    if (tableView.tag == 1000) {
        model.workType = 1;
    }else
    {
        if (model.state >3) {
        model.workType = 2;
        }else{
         model.workType = 1;
        }
        
    }
        cell.adminModel = model;
        cell.index = indexPath.row;
    }
    
    
     ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
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
    if(_dataUnAuthArray.count == 0){
        unAuthCount = 1;
        [self requestqueryAllUnAuthUserLockWithName:@""];
    }else{
        _dataArray = _dataUnAuthArray;
        
        UITableView *tableV = [_backScrollView viewWithTag:1000];
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
    [allBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
    [unAuthBtn setTitleColor:HexRGB(0x2e2e2e) forState:UIControlStateNormal];
    
//    if(_dataSouceArray.count == 0){
    adminCount = 1;
    [self requestqueryAllUserLockWithName:@""];
//    }else{
//        _dataArray = _dataSouceArray;
//
//        UITableView *tableV = [_backScrollView viewWithTag:1001];
//        [tableV reloadData];
//    }
    
    [UIView animateWithDuration:.3 animations:^{
        seperaView.center = CGPointMake(btn.center.x, seperaView .center.y);
        _backScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    }];
    
}

#pragma mark --WorkAdminManageDelegate ------同意或拒绝-----
- (void)clickAgreeWorkManageBtn:(NSInteger )index
{
    NSLog(@"同意");
    if (areaType == 9) {
        [SVProgressHUD showInfoWithStatus:@"您无权处理该工单"];
    }else{
        AdminModel *model = [_dataArray objectAtIndex:index];
        NSString *workName = model.workerName;
        NSString *roomName = model.roomName;
        NSString *message = [NSString stringWithFormat:@"提示:\n是否同意%@对%@机房提交的工单申请",workName,roomName];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:message
                                                                                 message:@""
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加同意到UIAlertController中
        [alertController addAction:[UIAlertAction actionWithTitle:@"是的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self requestAgreeOrFaultWithInteger:index stateType:5];
            
        }]];
        //添加取消到UIAlertController中
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
}

- (void)clickFaultWorkManageBtn:(NSInteger )index
{
    NSLog(@"拒绝");
    if (areaType == 9) {
       [SVProgressHUD showInfoWithStatus:@"您无权处理该工单"];
    }else{
        selectIndex = index;
        AdminModel *model = [_dataArray objectAtIndex:index];
        NSString *workName = model.workerName;
        NSString *roomName = model.roomName;
        NSArray *arr = @[@"联系用户已撤单，审批拒绝",@"线路故障需施工队处理，审批拒绝",@"其他"];
        //1.初始化
        XYChooseTypeAlertView *alertV = [[XYChooseTypeAlertView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) withTitleArray:arr];
        alertV.headMessage = [NSString stringWithFormat:@"提示:\n是否给%@拒绝%@工单装机",workName,roomName];
        
        //2.设置代理
        alertV.delegate = self;
        //3.显示
        [alertV showChooseTypeView];

    }
   
}

#pragma mark - 代理方法
- (void)chooseTypeAlertView:(XYChooseTypeAlertView *)alertView didSelectedIndex:(NSInteger)index
{
    //选择后调用
    NSLog(@"index = %zd",index);
     [self requestAgreeOrFaultWithInteger:selectIndex stateType:index+4];
}
- (void)chooseTypeAlertViewWillDisappear:(XYChooseTypeAlertView *)alertView
{
    NSLog(@"消失调用");
}

- (void)clickLiuzhuanWorkBtn:(NSInteger )row
{
    NSLog(@"工单流转");
    if (areaType == 9) {
        [SVProgressHUD showInfoWithStatus:@"您无权处理该工单"];
        return;
    }
    AdminModel *model = [_dataArray objectAtIndex:row];
    if (model.state != 1) {
        if (model.state == 2||model.state == 3) {
         [SVProgressHUD showInfoWithStatus:@"工单流转中"];
        }else if(model.state == 5){
            [SVProgressHUD showInfoWithStatus:@"审批已通过"];
        }else{
          [SVProgressHUD showInfoWithStatus:@"审批已拒绝"];
        }
        
    }else{
        ResourceCirculationController *vc = [[ResourceCirculationController alloc]init];
        vc.adminModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

- (void)requestAgreeOrFaultWithInteger:(NSInteger)index stateType:(NSInteger )state
{
    NSString *dateTime = [self dateStringWithDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *startTime = [self stringConversionDateTime:dateTime] ;
    
    AdminModel *model = [_dataArray objectAtIndex:index];
    
    if ([model.endTime doubleValue]<[startTime doubleValue]) {
        [SVProgressHUD showInfoWithStatus:@"操作失败,时间已过期！"];
        return ;
    }
    [self requestUpdateUserLockWith:model AndcheckOrdeState:state];
    
}

#pragma mark - refresh
-(void)refHeadView:(MJRefreshHeaderView *)headView{
    [self.view endEditing:YES];
    headview = headView;
    int indexNum = _backScrollView.contentOffset.x/SCREEN_WIDTH;
    if(indexNum == 0){
        UITableView *tableView = [_backScrollView viewWithTag:1000];
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
        customTableView *tableView = (customTableView *) [_backScrollView viewWithTag:1001];
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

- (void)back
{
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
