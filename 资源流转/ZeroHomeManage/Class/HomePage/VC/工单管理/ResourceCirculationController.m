//
//  ResourceCirculationController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/4/16.
//  Copyright © 2018年 TW. All rights reserved.
//流转详情-资源
//1374725674
#import "ResourceCirculationController.h"
#import "WorkAdminManageCell.h"
#import "ResoucecirCulationCell.h"
#import "CustPickerView.h"
#import "DataUtility.h"
#import "UserListModel.h"
#import "MJExtension.h"

static NSString *const WorkAdminManage = @"WorkAdminManageCell";
static NSString *const resouceCirculationCell = @"ResoucecirCulationCell";
@interface ResourceCirculationController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ResoucecirCulationCellDelegate>
@property(nonatomic,strong)UITableView *maintableView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)NSMutableArray *useListArray;
@property (nonatomic,strong)NSMutableArray *nameListArray;
@property (nonatomic,strong)NSMutableArray *telListArray;
@end

@implementation ResourceCirculationController
{
    UITextField *jieru_field;
    UIButton *userName_btn;
    NSString *userName;
    NSString *markPhone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.useListArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.nameListArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.telListArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self creatNavigation];
    [self creatTabaleView];
    [self postQueryMartingForRoomId];
}

#pragma mark ------自定义方法-------------
- (void)creatNavigation
{
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    self.title_lbl.text = @"流转详情-资源";

}

#pragma mark - CreatUI
- (void)creatTabaleView
{
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
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

#pragma mark - 查询该机房的营销人员

- (void)postQueryMartingForRoomId
{
        NSDictionary *parameters = @{@"token":usertoken,@"roomId":[NSNumber numberWithInteger:self.adminModel.roomId]};
        NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomQueryMarketingByRoomId];
        NSLog(@"xxxx==%@",parameters);
        [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
            
            NSLog(@"获取该机房的营销人员==:%@",jsonObj);
            if([[jsonObj objectForKey:@"success"]boolValue]){
                NSArray *userList = jsonObj[@"message"][@"constructionUserList"];
              for(NSDictionary *dic in userList)
              {
                  UserListModel *model = [UserListModel mj_objectWithKeyValues:dic];
                  [self.useListArray addObject:model];
                  [self.nameListArray addObject:model.realName];
                  [self.telListArray addObject:model.tel];
              }
                if (userList.count>0) {
                    userName = userList[0][@"realName"];
                    markPhone = userList[0][@"tel"];
                    [userName_btn setTitle:userName forState:UIControlStateNormal];
                }
                
            }
            
        } Error:^(NSString *errMsg, id jsonObj) {
            
            [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
        } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark - 工单流转（管理人员处理）

- (void)postWorkMessageInfoMationForResouce
{
    /*手机号码*/
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
   NSString *phoneNum = [ud objectForKey:@"iphoneNumber"];
    NSDictionary *parameters = @{@"token":usertoken,@"id":[NSNumber numberWithInteger:self.adminModel.ID],@"manageName":realName,@"manageTel":phoneNum,@"marketName":userName,@"marketTel":markPhone,@"workOrder":jieru_field.text};
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KRoomUpdateWokeOrderThrd];
    NSLog(@"xxxx==%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        
        NSLog(@"工单流转==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
            [SVProgressHUD showSuccessWithStatus:@"流转成功"];
            [self.navigationController popViewControllerAnimated:YES];
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
        ResoucecirCulationCell *cell = [tableView dequeueReusableCellWithIdentifier:resouceCirculationCell];
        if (cell == nil) {
            cell = [[NSBundle mainBundle]loadNibNamed:resouceCirculationCell owner:self options:nil][0] ;
            jieru_field = cell.jieru_field;
            userName_btn = cell.yingxiaoNameBtn;
            [cell.yingxiaoNameBtn addTarget:self action:@selector(clickYingxiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        //获取接入号
        cell.jieru_field.text = self.adminModel.workOrder;
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
        return 93;
    }
}

#pragma mark ---textfieldDelegate ----
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == jieru_field) {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == jieru_field) {
        return YES;
    }
    return NO;
}


- (void)clickYingxiaoBtn:(UIButton *)btn
{
    if (self.useListArray.count == 0) {
        [SVProgressHUD showInfoWithStatus:@"该机房暂无营销人员"];
    }else{
        CustPickerView *custpickerView = [[CustPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) AndDataSouce:self.nameListArray];
        __weak typeof (self)weakSealf = self;
        [custpickerView didFinishSelectedDate:^(NSString *selectedDate,NSInteger num) {
            [userName_btn setTitle:selectedDate forState:UIControlStateNormal];
            userName = selectedDate;
            markPhone = weakSealf.telListArray[num];
        }];
        NSLog(@"点击营销员");
    }
    
}

#pragma mark --- 提交工单流转信息-----
- (void)submit_Btn:(UIButton *)btn
{
    NSLog(@"====%@",userName_btn.currentTitle);
    if (![DataUtility isBlankObject:jieru_field.text]&&![DataUtility isBlankObject:userName_btn.currentTitle]) {
      [self postWorkMessageInfoMationForResouce];
    }else{
        [SVProgressHUD showSuccessWithStatus:@"流转信息不完整"];
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
