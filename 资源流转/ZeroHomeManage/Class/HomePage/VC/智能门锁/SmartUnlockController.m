//
//  SmartUnlockController.m
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "SmartUnlockController.h"
#import "CapacityUnlockController.h"


@interface SmartUnlockController ()

@end

@implementation SmartUnlockController
{
    UIView *without_view; //没有权限是的背景页面
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self creatNavigation];
    [self manageWithoutPermissionState];
//     [self requestQueryCheckUser];
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
    
    //右边按钮
    [self setRightButtonWithImageName:@"授权" action:@selector(clickRightBar)];
    
    UILabel *title_lbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
    title_lbl.font = FONT_SYSTEM(18);
    title_lbl.text = @"智能开锁";
    title_lbl.textColor = COLOR_RGB(79, 172, 246);
    title_lbl.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = title_lbl;
}



/*无权限状态 view*/

- (void)manageWithoutPermissionState
{
    without_view = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT)];
    without_view.backgroundColor = HexRGB(0xeeeeee);
    [self.view addSubview:without_view];
    
    UIImageView *backImage = [[UIImageView alloc]init];
    backImage.image = [UIImage imageNamed:@"插图"];
    backImage.contentMode = UIViewContentModeScaleAspectFill;
    [without_view addSubview:backImage];
    
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@65);
        make.centerX.equalTo(without_view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(272, 237));
    }];
    
    UILabel *without_lbl = [[UILabel alloc]init];
    without_lbl.text = @"没有权限！";
    without_lbl.font = Font(16);
    without_lbl.textColor = HexRGB(0x4facf6);
    [without_view addSubview:without_lbl];
    
    [without_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(backImage.mas_bottom).offset(40);
        make.centerX.equalTo(without_view.mas_centerX);
    }];
    
    UILabel *bottom_lbl = [[UILabel alloc]init];
    bottom_lbl.text = @"请点击右上角的按钮申请权限";
    bottom_lbl.font = Font(14);
    bottom_lbl.textColor = HexRGB(0x333333);
    [without_view addSubview:bottom_lbl];
    
    [bottom_lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(without_lbl.mas_bottom).offset(18);
        make.centerX.equalTo(without_view.mas_centerX);
    }];
}

#pragma mark ------NavigationRight-----
- (void)clickRightBar
{
    if (_authModel.type == 1) {
        //通网用户
        CapacityUnlockController *vc = [[CapacityUnlockController alloc]init];
        vc.peopleInfomation = NSKTongWang;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_authModel.type == 6){
        //管理员
        CapacityUnlockController *vc = [[CapacityUnlockController alloc]init];
        vc.peopleInfomation = NSKAdmin;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        //运营商或者物业
        CapacityUnlockController *vc = [[CapacityUnlockController alloc]init];
        vc.peopleInfomation = NSKYunying;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

#pragma mark ------back-----
- (void)back {
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
