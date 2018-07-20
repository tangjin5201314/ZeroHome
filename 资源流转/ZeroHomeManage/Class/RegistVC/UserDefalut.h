//
//  UserDefalut.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol userdelegate <NSObject>
@optional
-(void)IntervaltimeFixpassword;
//-(void)IntervaltimeRegpassword;
@end

@interface UserDefalut : NSObject

UIKIT_EXTERN NSString *usertoken;  //用户ID
extern NSString *phoneNumber;  //用户手机号
extern NSString *userName;    // 用户名
extern NSString *realName;     //一键开锁真实姓名
extern NSString *toothBlueState;
extern NSString *simMifiCard;   //sim卡号
extern NSString *userMifiId;    //用户mifiID
extern NSString *mifiRealName;  //mifi实名认证
extern NSString *selectWifiOrBoad;  //判断是点击WiFi还是宽带
extern NSString *portRoomID ;//机房ID
extern NSInteger areaType;  //身份类型

@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *iphoneNumber;
@property(nonatomic,strong)NSString *BranchID;
@property(nonatomic,strong)NSString *branchName;
@property(nonatomic,assign)int rank;

@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *versions;
@property(nonatomic,assign)int newrank;
@property(nonatomic,strong)NSString *describes;
@property(nonatomic,strong)NSString *gmtCreate;
//秒数
@property(nonatomic,assign)NSInteger timeFix;
@property(nonatomic,assign)NSInteger timeReg;
@property(nonatomic,assign)NSInteger timeQui;
@property(nonatomic,strong)NSTimer *timerFix;
@property(nonatomic,weak)__weak id<userdelegate>delegate;
//验证码
@property(nonatomic,strong)NSString *FixCheck;
@property(nonatomic,strong)NSString *RegCheck;
@property(nonatomic,strong)NSString *QuiLoginCheck;


-(void)StartTimeFixpassword;

+(instancetype)ShardUserDefalut;
-(void)setrelease:(NSDictionary *)dict;
-(void)setnewrelease:(NSDictionary *)dict;

//验证密码
@property(nonatomic,assign)BOOL isLogin;
//是否三方登陆
@property(nonatomic,assign)BOOL isThirdLogin;
//是否完善资料
@property(nonatomic,assign)BOOL isPerfect;
//openid
@property(nonatomic,strong)NSString *openId;
@property(nonatomic,strong)NSString *loginPassWord;

@end
