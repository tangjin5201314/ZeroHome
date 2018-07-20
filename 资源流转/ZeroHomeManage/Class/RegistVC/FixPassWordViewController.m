//
//  FixPassWordViewController.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "FixPassWordViewController.h"
#import "UIUtility.h"
#import "NSString+category.h"

@interface FixPassWordViewController ()

@end

@implementation FixPassWordViewController{
    BOOL text1;
    BOOL text2;
    BOOL text3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title_lbl.text = @"修改密码";
    //返回按钮
    [self setLeftButtonWithImageName:@"icon_back" action:@selector(back:)];
    
    [_Done.layer setMasksToBounds:YES];
    [_Done.layer setCornerRadius:5.0];
    text1=NO;
    text2 = NO;
    text3 = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_npassWordagain];
}
-(void)textFieldChanged{
        if ([_npassWordagain isEditing]){
        if([_npassWordagain.text isEqualToString: _npassWord.text]){
            _passwordRight.hidden = NO;
            _passwordlabel.hidden = YES;
            text3 = YES;
        }else{
            _passwordRight.hidden = YES;
            _passwordlabel.hidden = NO;
            text3 = NO;
        }
    }else if ([_npassWord isEditing]){
        if(_npassWord.text.length>0){
            text2 = YES;
            if([_npassWordagain.text isEqualToString: _npassWord.text]){
                if(_npassWordagain.text.length == 0){
                    _passwordRight.hidden = YES;
                    _passwordlabel.hidden = YES;
                }else{
                    _passwordRight.hidden = NO;
                    _passwordlabel.hidden = YES;
                }
                text3 = YES;
            }else{
                if(_npassWordagain.text.length == 0){
                    _passwordRight.hidden = YES;
                    _passwordlabel.hidden = YES;
                }else{
                    _passwordRight.hidden = YES;
                    _passwordlabel.hidden = NO;
                }
                text3 = NO;
                
            }
        }else{
            text2 = NO;
        }
        
    }
    NSLog(@"%d,%d,%d",text1,text2,text3);
}

- (IBAction)done:(id)sender {
    [self.view endEditing:YES];

    if(!text1){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入正确的原密码"];
    }else if (!text2){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"请输入新密码"];
    }else if (!text3){
        [UIUtility showAlertViewWithTitle:@"提示" messsge:@"两次输入密码不一致"];
    }else{
        [self ResetPassWord];
    }
}
-(void)ResetPassWord{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kchangePassWord];
    NSDictionary *parameters = [[NSDictionary alloc]initWithObjectsAndKeys:
                                [_npassWord.text stringFromMD5],@"pwd",
                                usertoken,@"token",
                                nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        NSLog(@"%@",jsonObj);
        NSLog(@"%d",[[jsonObj objectForKey:@"success"] boolValue]);
        if([[jsonObj objectForKey:@"success"] boolValue]){
            self.user.loginPassWord = _npassWord.text;
            [[NSUserDefaults standardUserDefaults] setObject:_npassWord.text forKey:@"PASSWORD"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UIUtility showAlertViewWithTitle:@"提示" messsge:@"修改密码成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        ;
    } Error:^(NSString *errMsg, id jsonObj) {
        
    } byUrl:URLStr parameters:parameters IsSava:NO delegate:self isRefresh:NO];
}
- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if(_oldPassWord==textField&&!text1){
        [self CheckOldPassWord];
    }
}
//验证旧密码
-(void)CheckOldPassWord{
    NSString *URLStr = [NSString stringWithFormat:@"%@%@",klAppBaseURL,kCheckOldPassWord];
    NSDictionary *paramenter = [[NSDictionary alloc]initWithObjectsAndKeys:
                                usertoken,@"token",
                                [_oldPassWord.text stringFromMD5],@"pwd",
                                nil];
    [self.http PostNewsWithFinish:^(NSString *errMsg, id jsonObj) {
        if([[jsonObj objectForKey:@"success"] boolValue]){
            text1 = YES;
            _oldPassWordright.hidden = NO;
            _oldpasswordlabel.hidden = YES;
            _oldPassWord.enabled = NO;
        }
    } Error:^(NSString *errMsg, id jsonObj) {
        ;
    } byUrl:URLStr parameters:paramenter IsSava:NO delegate:self isRefresh:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
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
