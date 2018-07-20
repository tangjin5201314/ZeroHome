//
//  OpenLockModel.h
//  ZeroHome
//
//  Created by TW on 16/12/6.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenLockModel : NSObject
@property (nonatomic,strong)NSString *op_time;
@property (nonatomic,assign)NSInteger op_way;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *user_mobile;
@end
