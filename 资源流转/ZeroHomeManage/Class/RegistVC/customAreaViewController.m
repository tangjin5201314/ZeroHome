//
//  customAreaViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "customAreaViewController.h"
#import "UIUtility.h"
#import "PersonSetViewController.h"

@interface customAreaViewController ()

@end

@implementation customAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back:)];

    [_done.layer setMasksToBounds:YES];
    [_done.layer setCornerRadius:5.0];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(SelectAddress)];
    [_cityView addGestureRecognizer:tap];
}
-(void)SelectAddress{

}
- (IBAction)Done:(id)sender {
    if(_wuye.text.length==0){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"物业名称不能为空"];
    }else if (_Area.text.length==0){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"小区名字不能为空"];
    }else if(_cityLabel.text.length == 0){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请选择城市"];
    }else if (_address.text.length==0){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"详细地址不能为空"];
    }else{
        if(_isEdit){
            [self FixArea];
        }else{
            PersonSetViewController *personSet = [[PersonSetViewController alloc]initWithNibName:@"PersonSetViewController" bundle:nil];
            personSet.iPhoneNumber =  _iPhoneNumber;
            personSet.branchId = [@"" intValue];
            personSet.AreaName =_Area.text;
            personSet.tenement = _wuye.text;
            personSet.address = _address.text;
            personSet.isPerfectData = _isPerfectData;
            [self.navigationController pushViewController:personSet animated:YES];
        }
    }
}
-(void)FixArea{
    //统计按钮点击次数
    NSDictionary *dict = @{@"type" : @"app_Center_MyHome_fixHome"};
    [MobClick event:@"app_Center_MyHome_fixHome" attributes:dict];
    
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kCustomCommunity];
    NSString *address = [NSString stringWithFormat:@"%@%@",_cityLabel.text,_address.text];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                usertoken,@"token",
                                _Area.text,@"branchName",
                                _wuye.text,@"tenement",
                                address,@"address",
                                nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"%@",jsonObj);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"修改小区成功"];
            self.user.BranchID = nil;
            self.user.branchName = nil;
            [self.navigationController popToViewController:[self.navigationController childViewControllers][1] animated:YES];
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
- (void)back:(id)sender {
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
