//
//  smallAreaModel.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface smallAreaModel : NSObject

@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *branchName;
@property(nonatomic,strong)NSString *AreaID;

-(instancetype)initWith:(NSDictionary *)dict;
@end
