//
//  SelectAreaViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "SelectAreaViewController.h"
#import "NSString+category.h"
#import "smallAreaTableViewCell.h"
#import "PersonSetViewController.h"
#import "smallAreaModel.h"
#import "MJRefresh.h"
#import "customAreaViewController.h"
#import "UIUtility.h"
@interface SelectAreaViewController ()<MJRefreshBaseViewDelegate>

@end

@implementation SelectAreaViewController{
    int pageNum;
    
    MJRefreshFooterView *footView;
    MJRefreshHeaderView *headView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"选择小区";

    pageNum = 1;
    _dataArray = [[NSMutableArray alloc]init];
    
    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_searchArea];
    headView.delegate = self;
    footView = [[MJRefreshFooterView alloc]initWithScrollView:_searchArea];
    footView.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchArea.backgroundColor = [UIColor colorWithRed:0.93f green:0.94f blue:0.94f alpha:1.00f];
    [self setExtraCellLineHidden:_searchArea];
    [self loadData];
    
}
-(void)loadData{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kQueryArea];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                              [NSNumber numberWithInt:pageNum],@"pageNum",
                              [NSNumber numberWithInt:10],@"pageSize",
                              nil];
    NSLog(@"%@",parameters);
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        if([[jsonObj objectForKey:@"success"] boolValue]){
            if(pageNum > [jsonObj[@"message"][@"communityPage"][@"pages"] intValue]){
                if([headView isRefreshing]){
                    [headView endRefreshing];
                }
                if([footView isRefreshing]){
                    [footView endRefreshing];
                }
                return ;
            }
            if(pageNum == 1){
                [_dataArray removeAllObjects];
            }
            
            NSDictionary *message = [jsonObj objectForKey:@"message"];
            NSDictionary *communityPage = [message objectForKey:@"communityPage"];
            NSDictionary *list = [communityPage objectForKey:@"list"];
            for (NSDictionary *dict in list) {
                smallAreaModel *model = [[smallAreaModel alloc]initWith:dict];
                [_dataArray addObject:model];
            }
            [_searchArea reloadData];
            
        }
        if([headView isRefreshing]){
            [headView endRefreshing];
        }
        if([footView isRefreshing]){
            [footView endRefreshing];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        if([headView isRefreshing]){
            [headView endRefreshing];
        }
        if([footView isRefreshing]){
            [footView endRefreshing];
        }
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}


- (IBAction)back:(UIButton *)sender {
     [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)custom:(id)sender {
    customAreaViewController *customAreaVC = [[customAreaViewController alloc]initWithNibName:@"customAreaViewController" bundle:nil];
    if(_isEdit){
        customAreaVC.isEdit = YES;
    }if(_isPerfectData){
        customAreaVC.isPerfectData = _isPerfectData;
    }
    customAreaVC.iPhoneNumber = _iPhoneNumber;
    [self.navigationController pushViewController:customAreaVC animated:YES];
}
- (IBAction)skip:(id)sender {
    if(_isEdit){
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    PersonSetViewController *personSet = [[PersonSetViewController alloc]initWithNibName:@"PersonSetViewController" bundle:nil];
    personSet.iPhoneNumber =  _iPhoneNumber;
    personSet.AreaName = @"";
    personSet.tenement = @"";
    personSet.address = @"";
    personSet.isPerfectData = _isPerfectData;
    [self.navigationController pushViewController:personSet animated:YES];
}
#pragma mark - UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    smallAreaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"smallAreaTableViewCell" owner:self options:nil][0];
    }
    cell.SmallAreaModel = [_dataArray objectAtIndex:indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    _search = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _search.placeholder = @"搜索小区";
    _search.delegate = self;
    return _search;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    smallAreaModel *model = [_dataArray objectAtIndex:indexPath.row];
    if(_isEdit){
        [self FixArea:model.AreaID];
        return;
    }
    
    PersonSetViewController *personSet = [[PersonSetViewController alloc]initWithNibName:@"PersonSetViewController" bundle:nil];
    personSet.iPhoneNumber =  _iPhoneNumber;
    personSet.branchId = [model.AreaID intValue];
    personSet.AreaName = model.branchName;
    personSet.tenement = @"";
    personSet.address = @"";
    personSet.isPerfectData = _isPerfectData;
    
    
    [self.navigationController pushViewController:personSet animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44.0f;
}
- (void)setExtraCellLineHidden: (UITableView *)tableView{
    
    UIView *view =[ [UIView alloc]init];
    
    view.backgroundColor = [UIColor clearColor];
    
    [tableView setTableFooterView:view];
    
    [tableView setTableHeaderView:view];
    
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if(headView == refreshView){
        pageNum = 1;
        
        [self loadData];
    }else if (footView == refreshView){
        pageNum++;
        [self loadData];
    }

}
-(void)FixArea:(NSString *)ListId{
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"app_Center_MyHome_fixHome"};
    [MobClick event:@"app_Center_MyHome_fixHome" attributes:dict];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kListCommunity];
   
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                usertoken,@"token",
                                [NSNumber numberWithInt:[ListId intValue]],@"id",
                                nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"修改小区===%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            
            [SVProgressHUD showSuccessWithStatus:@"修改小区成功"];
            NSString *point = [[jsonObj objectForKey:@"message"]objectForKey:@"point"];
            if ([point integerValue]>0) {
                [ShowSignHUB showSignInfo:[NSString stringWithFormat:@"积分 +%@",point]];
                //修改小区成功通知，积分+
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHCOMMITNOTIFICATION" object:nil userInfo:nil];
            }
            self.user.branchName = nil;
            self.user.BranchID = nil;
            [self.navigationController popToViewController:[self.navigationController childViewControllers][1] animated:YES];
            

        }
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}


-(void)dealloc{
    [headView free];
    [footView free];
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
