//
//  signinModel.m
//  ZeroHome
//
//  Created by TW on 16/4/14.
//  Copyright © 2016年 TW. All rights reserved.
//

#import "signinModel.h"

@implementation signinModel


-(instancetype)initWith:(NSDictionary *)dict
{
    id monthSigninFlag = [dict objectForKey:@"monthSigninFlag"];
    if([self isNull:monthSigninFlag]){
        self.monthSigninFlag = monthSigninFlag;
    }
    
    id signined = [dict objectForKey:@"signined"];
    if([self isNull:signined]){
        self.signined = signined;
    }
    
    id totalSigninlFlag = [dict objectForKey:@"totalSigninlFlag"];
    if([self isNull:totalSigninlFlag]){
        self.totalSigninlFlag = totalSigninlFlag;
    }
    
    id userId = [dict objectForKey:@"userId"];
    if([self isNull:userId]){
        self.userId = userId;
    }
    
    id point = [dict objectForKey:@"point"];
    if([self isNull:point]){
        self.point = point;
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
