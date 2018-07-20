//
//  AboutWeViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "AboutWeViewController.h"

@interface AboutWeViewController ()
@property (nonatomic,strong) NSString *strVerUrl;
@property (weak, nonatomic) IBOutlet UILabel *versin_lbl;

@end

@implementation AboutWeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title_lbl.text = @"关于我们";
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back:)];
    // Do any additional setup after loading the view from its nib.
    
    //版本号
    NSString *vesion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _versin_lbl.text = [NSString stringWithFormat:@"V%@",vesion];
}
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ZoreHome:(id)sender {
    NSLog(@"xieyi");
}
- (IBAction)weixin:(id)sender {
    NSLog(@"weixingongzhonghao");
    

}

- (IBAction)updateVersion:(id)sender {
    NSString *urlStr = @"http://itunes.apple.com/lookup?id=954684084";
    [self.http Post1NewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSDictionary* results = [[jsonObj objectForKey:@"results"] objectAtIndex:0];
        if (results) {
            NSString  *fVeFromNet = [results objectForKey:@"version"];
            NSLog(@"results===%@",results);
            _strVerUrl = [results objectForKey:@"trackViewUrl"];
            NSLog(@"版本：%@",_strVerUrl);
            if (0 < fVeFromNet && _strVerUrl) {
                NSString *fCurVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                NSLog(@"版本====%@",fCurVer);
                if (![fCurVer isEqualToString:fVeFromNet]) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                      [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_strVerUrl]];
                       
                    });
                }else{
                    [SVProgressHUD showInfoWithStatus:@"已经是最新版本了"];
                }
            }
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        
    } byUrl:urlStr parameters:nil IsSava:NO delegate:self isRefresh:YES];
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
