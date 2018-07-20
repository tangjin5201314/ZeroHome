//
//  MarketingCicleManageController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//
//流转记录----营销
#import "MarketingCicleManageController.h"
#import "customTableView.h"
#import "WorkAdminManageCell.h"
#import "MarketingCicleController.h"
#import "AdminModel.h"
#import "MJExtension.h"

@interface MarketingCicleManageController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,MYTableViewDelegate>
@property (nonatomic,strong)UIScrollView *backScrollView;
@property (nonatomic,strong)customTableView *maintableView;
@property (nonatomic,strong)NSMutableArray *dataSouceArray;  //全部
@property (nonatomic,strong)NSMutableArray *dataUnAuthArray; //未授权
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)UISearchBar *searchBar;
@end

@implementation MarketingCicleManageController
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
    self.title_lbl.text = @"流转记录-营销";
    
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
        _maintableView.tag = i+1000;
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
        
        [_maintableView registerNib:[UINib nibWithNibName:@"WorkAdminManageCell" bundle:nil] forCellReuseIdentifier:@"WorkAdminManageCell"];
    }
    
}

#pragma mark - 获取未审核列表
- (void)requestqueryAllUnAuthUserLockWithName:(NSString *)name
{
//     [_dataUnAuthArray removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomOrderListByState];
    NSDictionary *parameters = @{@"token":usertoken,@"type":[NSNumber numberWithInteger:areaType],@"pageNum":[NSNumber numberWithInt:unAuthCount],@"pageSize":[NSNumber numberWithInt:10],@"workerName":name,@"state":[NSNumber numberWithInt:2]};
    
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            if (unAuthCount == 1) {
                [_dataUnAuthArray removeAllObjects];
            }
            if ([jsonObj[@"message"][@"roomOrderList"][@"pages"]intValue]==0) {
                [SVProgressHUD showInfoWithStatus:@"暂无未授权的信息"];
                UITableView *customTable = [_backScrollView viewWithTag:1000];
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

#pragma mark - 获取所有审核列表
- (void)requestqueryAllUserLockWithName:(NSString *)name
{
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

#pragma mark -----tableViewDelegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (tableView.tag == 1000) {
        UITableView *customTable = [_backScrollView viewWithTag:1000];
        return [customTable cellHeightForIndexPath:indexPath model:model keyPath:@"adminModel" cellClass:[WorkAdminManageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }else {
        UITableView *customTable = [_backScrollView viewWithTag:1001];
        return [customTable cellHeightForIndexPath:indexPath model:model keyPath:@"adminModel" cellClass:[WorkAdminManageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkAdminManageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkAdminManageCell"];
    AdminModel *model = [_dataArray objectAtIndex:indexPath.row];
    model.workType = 2;
    cell.adminModel = model;
//    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ////// 此步设置用于实现cell的frame缓存，可以让tableview滑动更加流畅 //////
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdminModel *model = [_dataArray objectAtIndex:indexPath.row];
    if (model.state == 1 ||model.state == 2) {
        MarketingCicleController *vc = [[MarketingCicleController alloc]init];
        vc.adminModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
   
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
        [_dataArray removeAllObjects];
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
//    if (adminCount == 1) {
//        _dataArray = _dataSouceArray;
//
//        UITableView *tableV = [_backScrollView viewWithTag:1001];
//        [tableV reloadData];
//        return;
//    }
        [_dataArray removeAllObjects];
    [allBtn setTitleColor:HexRGB(0x4facf6) forState:UIControlStateNormal];
    [unAuthBtn setTitleColor:HexRGB(0x2e2e2e) forState:UIControlStateNormal];
    
    if(_dataSouceArray.count == 0){
        adminCount = 1;
        [self requestqueryAllUserLockWithName:@""];
    }else{
        _dataArray = _dataSouceArray;
        
        UITableView *tableV = [_backScrollView viewWithTag:1001];
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
        UITableView *tableView = [_backScrollView viewWithTag:1001];
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

-(void)dealloc{
    for(customTableView *tableview in _backScrollView.subviews){
        if([tableview isKindOfClass:[customTableView class]]){
            [tableview Todealloc];
        }
    }
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
