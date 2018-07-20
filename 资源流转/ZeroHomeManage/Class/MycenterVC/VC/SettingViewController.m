//
//  SettingViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingTableViewCell.h"
#import "AboutWeViewController.h"
#import "DelegateViewController.h"
#import "gongzhonghaoViewController.h"
#import "AppDelegate.h"
#import "BPush.h"
#import "FirstViewController.h"
#import "LoginViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title_lbl.text = @"设置";
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back:)];

    
    _dataArray = [[NSArray alloc]init];
//    NSArray *array1 = [[NSArray alloc]initWithObjects:@"信息推送", nil];
//    NSArray *array2 = [[NSArray alloc]initWithObjects:@"微信公众号",@"服务协议",@"功能引导页", nil];
//    NSArray *array3 = [[NSArray alloc]initWithObjects:@"关于我们", nil];
//    [_dataArray addObject:array1];
//    [_dataArray addObject:array2];
//    [_dataArray addObject:array3];
    _dataArray = @[@[@"信息推送"],@[@"微信公众号",@"服务协议",@"功能引导页"],@[@"关于我们"]];
    
    
    _SettableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, SCREEN_HEIGHT-65) style:UITableViewStyleGrouped];
    _SettableView.delegate = self;
    _SettableView.dataSource = self;
    _SettableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _SettableView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.93f alpha:1.00f];
    [self.view addSubview:_SettableView];

    UIView *FootView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 108)];
    FootView.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
    UIButton *quit = [UIButton buttonWithType:UIButtonTypeCustom];
    quit.frame = CGRectMake(0, 30, SCREEN_WIDTH, FootView.height-60);
    [quit setTitle:@"退出登录" forState:UIControlStateNormal];
    quit.titleLabel.font = [UIFont systemFontOfSize:15];
    [quit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    quit.backgroundColor = [UIColor whiteColor];
    [quit addTarget:self action:@selector(Quit:) forControlEvents:UIControlEventTouchUpInside];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREEN_WIDTH, 0.5)];
    topView.backgroundColor = COLOR_RGB(200, 199, 204);
    [FootView addSubview:topView];
    UIView *bottmView = [[UIView alloc]initWithFrame:CGRectMake(0, quit.bottom, SCREEN_WIDTH, 0.5)];
    bottmView.backgroundColor = COLOR_RGB(200, 199, 204);
    [FootView addSubview:bottmView];
    [FootView addSubview:quit];
    if (!usertoken) {
        _SettableView.tableFooterView = [UIView new];
    }else{
         _SettableView.tableFooterView = FootView;
    }
   

}
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)tuisongSwitch:(UISwitch *)sw{
    if(sw.isOn){
        NSLog(@"打开");
        [self registerPush];
        
    }else{
        NSLog(@"关闭");
        [self offPush];

    }
}
-(void)registerPush{
#warning 测试 开发环境 时需要修改BPushMode为BPushModeDevelopment 需要修改Apikey为自己的Apikey
     AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];    [BPush registerDeviceToken:app.deviceToken];
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        //[self.viewController addLogString:[NSString stringWithFormat:@"Method: %@\n%@",BPushRequestMethodBind,result]];
        // 需要在绑定成功后进行 settag listtag deletetag unbind 操作否则会失败
        NSLog(@"%@,%@",result,error);
        if (result) {
            [BPush setTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if (result) {
                    NSLog(@"设置tag成功");
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"allowPush"];
                }
            }];
        }
    }];
}
-(void)offPush{
    [BPush unbindChannelWithCompleteHandler:^(id result, NSError *error) {
        if(result){
            [BPush delTag:@"Mytag" withCompleteHandler:^(id result, NSError *error) {
                if(result){
                    NSLog(@"注销成功");
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"allowPush"];
                }
            }];
        }
    }];
}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return [[_dataArray objectAtIndex:section]count];
    NSArray *array = [_dataArray objectAtIndex:section];
    return array.count;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cell";
    SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"SettingTableViewCell" owner:self options:nil][0];
        
    }
    if (indexPath.row==0&&indexPath.section==0) {
        [cell.rightJian removeFromSuperview];
        UISwitch *tuisong = [[UISwitch alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-71, 7, 51, 31)];
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"allowPush"] boolValue]){
            tuisong.on = YES;
        }else{
            tuisong.on = NO;
        }
        
        [tuisong addTarget:self action:@selector(tuisongSwitch:) forControlEvents:UIControlEventValueChanged];
        tuisong.onTintColor = [UIColor colorWithRed:0.31f green:0.67f blue:0.97f alpha:1.00f];
        [cell.contentView addSubview:tuisong];
    }
    cell.titleLabel.text = [[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 18;
    }
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 1:
            if(indexPath.row==0){
                 [self pushGongzhonghao];
               

            }else if (indexPath.row==1){
                [self xieyi];
            
            }else if (indexPath.row==2){
                [self PushUserCenter];
            }
            break;
        case 2:
            if(indexPath.row==0){
               [self PushAboutWe];
            }
            break;

        default:
            break;
    }
}
-(void)PushAboutWe{
    AboutWeViewController *aboutme = [[AboutWeViewController alloc]initWithNibName:@"AboutWeViewController" bundle:nil];
    [self.navigationController pushViewController:aboutme animated:YES];
}
-(void)PushUserCenter{
    FirstViewController *first = [[FirstViewController alloc]initWithNibName:@"FirstViewController" bundle:nil];
    first.isSetPush = YES;
    [self.navigationController pushViewController:first animated:YES];
}
-(void)xieyi{
    DelegateViewController *service = [[DelegateViewController alloc]initWithNibName:@"DelegateViewController" bundle:nil];
    [self.navigationController pushViewController:service animated:YES];
}
-(void)pushGongzhonghao{
    gongzhonghaoViewController *gongzhongVC = [[gongzhonghaoViewController alloc]initWithNibName:@"gongzhonghaoViewController" bundle:nil];
    [self.navigationController pushViewController:gongzhongVC animated:YES];
}

//退出登陆
-(void)Quit:(UIButton *)btn{
    //清除沙盒数据
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"token"];
    [ud removeObjectForKey:@"iphoneNumber"];
    [ud removeObjectForKey:@"saveLockName"];
    self.user.token = nil;
    self.user.loginPassWord = nil;
    self.user.isLogin = NO;
    self.user.isThirdLogin = NO;
    self.user.BranchID = nil;
    self.user.branchName = nil;
    usertoken = nil;
    phoneNumber = nil;
    userName = nil;
    
    [ud removeObjectForKey:@"yezhu"];
    [ud removeObjectForKey:@"roow"];
    [ud removeObjectForKey:@"roowNum"];
    [ud removeObjectForKey:@"push"];
    
    /*清楚24小时存储的数据*/
    NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents/date.text"];
    [[NSFileManager defaultManager] removeItemAtPath:path error:nil];

    
     AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    LoginViewController *login = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:login];
    delegate.window.rootViewController = nav;
    
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
