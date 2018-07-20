//
//  userCenterModel.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "userCenterModel.h"

@implementation userCenterModel
-(instancetype)initWith:(NSDictionary *)dict
{
    id headPortrait = [dict objectForKey:@"headPortrait"];
    if([self isNull:headPortrait]){
        self.headPortrait = headPortrait;
    }
    
    id nickname = [dict objectForKey:@"nickname"];
    if([self isNull:nickname]){
        self.nickname = nickname;
    }
    
    id pointLevel = [dict objectForKey:@"pointLevel"];
    if([self isNull:pointLevel]){
        self.pointLevel = pointLevel;
    }
    
    id userId = [dict objectForKey:@"userId"];
    if([self isNull:userId]){
        self.userId = userId;
    }
    
    id sex = [dict objectForKey:@"sex"];
    if([self isNull:sex]){
        self.sex = sex;
    }
    
    id validPoint = [dict objectForKey:@"validPoint"];
    if([self isNull:validPoint]){
        self.validPoint = validPoint;
    }
    
    return self;
}

-(BOOL)isNull:(NSString *)Object{
    if(Object==nil||[Object isKindOfClass:[NSNull class]]||Object==NULL){
        return NO;
    }
    return YES;
}
@end
