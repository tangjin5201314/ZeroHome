//
//  AutheTimeListModel.h
//  ZeroHome
//
//  Created by TW on 16/12/5.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutheTimeListModel : NSObject
@property (nonatomic,assign)NSInteger checkOrder;
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *failReason;
@property (nonatomic,strong)NSString *startTime;

@property (nonatomic,strong)NSString *workerName;
@property (nonatomic,strong)NSString *workerTel;
@property (nonatomic,strong)NSString *workerReason;
@property (nonatomic,strong)NSString *createTime;
@property (nonatomic,strong)NSString *workOrder;
@property (nonatomic,assign)NSInteger state;
@property (nonatomic,assign)NSInteger type;
@end
