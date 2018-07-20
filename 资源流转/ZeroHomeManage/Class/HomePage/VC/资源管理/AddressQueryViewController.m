//
//  AddressQueryViewController.m
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/5/24.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "AddressQueryViewController.h"
#import "AdressQueryTableViewCell.h"
#import "AdressListModel.h"
#import "MJExtension.h"
static NSString *const AdressQueryCell =@"AdressQueryTableViewCell";
@interface AddressQueryViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,UITextFieldDelegate,AdressQueryCellDelegate>
@property(nonatomic,strong)UITableView *maintableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,weak)UITextField *address_tf;
@property (nonatomic,weak)UIButton *query_btn;
@end

@implementation AddressQueryViewController
{
    int adressCount;
    MJRefreshHeaderView *headView;
    MJRefreshFooterView *footView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title_lbl.text = @"地址查询";
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back)];
    
    self.dataArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [self setTableView];
}

- (void)setTableView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    _maintableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _maintableView.backgroundColor = HexRGB(0xeeeeee);
    _maintableView.delegate = self;
    _maintableView.dataSource = self;
    _maintableView.tableFooterView = [UIView new];
    _maintableView.backgroundColor = COLOR_RGB(237, 237, 240);
    [self.view addSubview:_maintableView];
    
//    headView = [[MJRefreshHeaderView alloc]initWithScrollView:_maintableView];
//    footView = [[MJRefreshFooterView alloc]initWithScrollView:_maintableView];
//    headView.delegate = self;
//    footView.delegate = self;
    
    UINib *nib = [UINib nibWithNibName:AdressQueryCell bundle:nil];
    [_maintableView registerNib:nib forCellReuseIdentifier:AdressQueryCell];
}

#pragma mark - 根据现地址查询机房端口
- (void)requestAdressPortWithAdress:(NSString *)address
{
    [self.dataArray removeAllObjects];
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,KQueryPordAndRoomadress];
    NSDictionary *parameters = @{@"token":usertoken,@"roomId":[NSNumber numberWithInteger:self.roomID],@"newA":address};
    NSLog(@"消息字典：%@",parameters);
    [self.http PostRequestDataWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"消息推送记录==:%@",jsonObj);
        if([[jsonObj objectForKey:@"success"]boolValue]){
       
            NSArray *pushListArray = jsonObj[@"message"][@"posts"];
            if (pushListArray.count == 0) {
                [SVProgressHUD showInfoWithStatus:@"未查到地址信息"];
               
            }
            for(NSDictionary *dic in pushListArray)
            {
                AdressListModel *model = [AdressListModel mj_objectWithKeyValues:dic];
                [_dataArray addObject:model];
            }
            [_maintableView reloadData];
        }else{
          [SVProgressHUD showInfoWithStatus:jsonObj[@"reason"]];
        }
        
    } Error:^(NSString *errMsg, id jsonObj) {
        
        [SVProgressHUD showErrorWithStatus:@"服务器开小差了~"];
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:YES];
}


#pragma mark ----CustomDelegate-----
- (void)textFieldEditChangeWithText:(NSString *)address
{
    [self requestAdressPortWithAdress:address];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
       AdressQueryTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:AdressQueryCell];
        _address_tf = cell.adress_texfield;
        _address_tf.delegate = self;
        [cell.queryBtn addTarget:self action:@selector(clickQueryAdressBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegage = self;
        return cell;
    }else if(indexPath.section == 1){
        static NSString *cellName = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
        
        if(cell==nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
            cell.backgroundColor = [UIColor whiteColor];
            cell.textLabel.font = Font(12);
            [cell.textLabel setAdjustsFontSizeToFitWidth:YES];
            
        }
        if (indexPath.row<=self.dataArray.count) {
           AdressListModel *model = [self.dataArray objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"位置:%ld:%@ 机房 %@机柜 第%ld行 第%ld列",indexPath.row+1 ,self.lockName,model.equipmentCode,model.trayCode,model.portSort];
        }
        
        return cell;
    }
        return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 58;
    }
    return 44;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    headView.backgroundColor = COLOR_RGB(237, 237, 240);
    
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(13, 5, SCREEN_WIDTH, 21)];
    title_lbl.font = [UIFont systemFontOfSize:14];
    title_lbl.textColor = COLOR_RGB(102, 102, 102);
    if (section == 0) {
        title_lbl.text = @"在机房内地址模糊查询";
    }else{
        title_lbl.text = @"地址列表";
    }
    
    
    [headView addSubview:title_lbl];
    return headView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 31;
}


- (void)clickQueryAdressBtn:(UIButton *)btn
{
    
}

- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
//    if (headView == refreshView) {
//        roomTimeCount = 1;
//        [self requestQueryUserbyTelWithRoomId];
//    }else if (footView == refreshView){
//        roomTimeCount ++;
//        [self requestQueryUserbyTelWithRoomId];
//    }
}

-(void)dealloc{
    [headView free];
    [footView free];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
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
