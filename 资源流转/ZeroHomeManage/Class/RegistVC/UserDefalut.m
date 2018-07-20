//
//  UserDefalut.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "UserDefalut.h"
NSString * usertoken;
NSString * phoneNumber;
NSString * userName;
NSString * realName;
NSString * toothBlueState;
NSString * simMifiCard;
NSString * userMifiId;
NSString * mifiRealName;
NSString * selectWifiOrBoad;
NSString *portRoomID;
NSInteger areaType;


@implementation UserDefalut

static UserDefalut *user;
+(instancetype)ShardUserDefalut{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       user = [[UserDefalut alloc]init];
    });
    return user;
}

-(void)setrelease:(NSDictionary *)dict{
    id rank = [dict objectForKey:@"rank"];
    if([self isNull:rank]){
        self.rank = [rank intValue];
    }
    
    id token = [dict objectForKey:@"token"];
    if([self isNull:token]){
        self.token = token;
    }
    
}
-(void)setnewrelease:(NSDictionary *)dict{
    id versions = [dict objectForKey:@"versions"];
    if([self isNull:versions]){
        self.versions = versions;
    }
    id newrank = [dict objectForKey:@"newrank"];
    if([self isNull:newrank]){
        self.newrank = [newrank intValue];
    }
    id address = [dict objectForKey:@"address"];
    if([self isNull:address]){
        self.address = address;
    }
    id describes = [dict objectForKey:@"describes"];
    if([self isNull:describes]){
        self.describes = describes;
    }
    id gmtCreate = [dict objectForKey:@"gmtCreate"];
    if([self isNull:gmtCreate]){
        self.gmtCreate = gmtCreate;
    }
    
}
-(BOOL)isNull:(NSString *)Object{
    if(Object==nil||[Object isKindOfClass:[NSNull class]]||Object==NULL){
        return NO;
    }
    return YES;
}
//修改密码
-(void)StartTimeFixpassword{
    if (_timerFix == nil) {
        _timerFix = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(Interval) userInfo:nil repeats:YES];
    }
}
-(void)Interval{
    if(_timeFix>0){
        _timeFix--;
        //[_delegate IntervaltimeFixpassword];
    }
    if(_timeReg>0){
        _timeReg--;
    }
    if(_timeQui>0){
        _timeQui--;
        
    }
    [_delegate IntervaltimeFixpassword];
    if(_timeFix==0&&_timeReg==0&&_timeQui==0){
        [_timerFix invalidate];
        _timerFix = nil;
    }
}
@end
