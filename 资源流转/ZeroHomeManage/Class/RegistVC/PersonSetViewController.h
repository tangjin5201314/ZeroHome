//
//  PersonSetViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface PersonSetViewController : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *Email;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UIButton *man;
@property (weak, nonatomic) IBOutlet UIButton *wuman;
@property (weak, nonatomic) IBOutlet UITextField *Area;
@property (weak, nonatomic) IBOutlet UIButton *yuedu;
@property (weak, nonatomic) IBOutlet UIButton *mydelegate;
@property (weak, nonatomic) IBOutlet UIButton *Done;
@property (weak, nonatomic) IBOutlet UITextField *NickName;

@property(nonatomic,strong)NSString *iPhoneNumber;
@property(nonatomic,assign)int AreaID;
@property(nonatomic,assign)int branchId;
@property(nonatomic,strong)NSString *AreaName;


@property(nonatomic,strong)NSString *tenement;
@property(nonatomic,strong)NSString *address;

//是否是完善资料
@property(nonatomic,assign)BOOL isPerfectData;
@end
