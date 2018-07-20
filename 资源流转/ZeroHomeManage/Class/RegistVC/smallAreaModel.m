//
//  smallAreaModel.m
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "smallAreaModel.h"

@implementation smallAreaModel
-(instancetype)initWith:(NSDictionary *)dict{
    id address = [dict objectForKey:@"address"];
    if([self isNull:address]){
        self.address = address;
    }
    
    id branchName = [dict objectForKey:@"branchName"];
    if([self isNull:branchName]){
        self.branchName = branchName;
    }
    
    id AreaID = [dict objectForKey:@"id"];
    if([self isNull:AreaID]){
        self.AreaID = AreaID;
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
