//
//  MarketingCicleController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//流转详情 ---- 营销

#import "MarketingCicleController.h"
#import "WorkAdminManageCell.h"
#import "MarketingCirculationCell.h"

@interface MarketingCicleController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *maintableView;
@property (nonatomic,strong)UIView *footView;
@end


static NSString *const WorkAdminManage = @"WorkAdminManageCell";
static NSString *const MarketingCirculation = @"MarketingCirculationCell";
@implementation MarketingCicleController
{
    NSInteger markState;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatNavigation];
    [self creatTabaleView];
    
    markState = 1;
}


#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    self.title_lbl.text = @"流转详情-营销";
}

#pragma mark - CreatUI
- (void)creatTabaleView
{
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-44) style:UITableViewStylePlain];
    _maintableView.backgroundColor = HexRGB(0xeeeeee);
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    [_maintableView setTableFooterView:self.footView];
    _maintableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_maintableView];
    
}

- (UIView *)footView
{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIButton *submit_btn = [[UIButton alloc]init];
    submit_btn.frame = CGRectMake(18, 25, SCREEN_WIDTH-36, 35);
    [submit_btn setTitle:@"提交流转信息" forState:UIControlStateNormal];
    [submit_btn setBackgroundImage:[UIImage imageNamed:@"rounder"] forState:UIControlStateNormal];
    [submit_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submit_btn addTarget:self action:@selector(submit_Btn:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:submit_btn];
    
    
    return footView;
}

#pragma mark - 工单流转（营销人员处理）

- (void)postWorkMessageInfoMationForMarketing
{
    NSDictionary *parameters = @{@"token":usertoken,@"id":[NSNumber numberWithInteger:self.adminModel.ID],@"marketState":[NSNumber numberWithInteger:markState]};
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomUpdateWorkOrderTwo];
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        
        NSLog(@"工单流转==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            [SVProgressHUD showInfoWithStatus:@"提交信息成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}

#pragma mark ----tableViewDelegate------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        WorkAdminManageCell *cell = [tableView dequeueReusableCellWithIdentifier:WorkAdminManage];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:WorkAdminManage owner:self options:nil][0] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        self.adminModel.workType = 3;
        cell.adminModel = self.adminModel;
        return cell;
        
    }else{
        MarketingCirculationCell *cell = [tableView dequeueReusableCellWithIdentifier:MarketingCirculation];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:MarketingCirculation owner:self options:nil][0] ;
        }
        cell.block = ^(NSInteger messageInt) {
            markState = messageInt;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return [tableView cellHeightForIndexPath:indexPath model:self.adminModel keyPath:@"adminModel" cellClass:[WorkAdminManageCell class] contentViewWidth:[UIScreen mainScreen].bounds.size.width];
    }else{
        return 117;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 29;
}

#pragma mark --- 提交营销信息----
- (void)submit_Btn:(UIButton *)btn
{
    [self postWorkMessageInfoMationForMarketing];
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
