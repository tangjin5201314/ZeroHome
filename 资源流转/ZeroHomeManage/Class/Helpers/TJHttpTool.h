//
//  TJHttpTool.h
//  ZeroHome
//
//  Created by TW on 17/9/19.
//  Copyright © 2017年 tangjin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void (^SuccessBlock)(id JSON);
typedef void (^FailedBlock)(NSError *error);

@interface TJHttpTool : NSObject

//+ (void)postWithPath:(NSString *)path param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;


+ (void)requestWithPath:(NSString *)path param:(NSDictionary *)param success:(SuccessBlock)success failure:(FailedBlock)failure;

//判断是否连接成功
+ (void)requestisConnectWebserviceWithSuccess:(SuccessBlock)success failure:(FailedBlock)failure;

+ (void)requestDownLoadWorkListWithSuccess:(SuccessBlock)success failure:(FailedBlock)failure;

+(void)requestDownLOadWorkDetailWithWorkID:(NSString *)workId Success:(SuccessBlock)success failure:(FailedBlock)failure;
@end
