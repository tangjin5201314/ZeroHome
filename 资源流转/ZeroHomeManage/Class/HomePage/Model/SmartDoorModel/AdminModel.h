//
//  AdminModel.h
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdminModel : NSObject
@property (nonatomic,assign)NSInteger checkOrder; /*1.同意  2.拒绝  4.审核*/
@property (nonatomic,strong)NSString *endTime;
@property (nonatomic,strong)NSString *failReason;
@property (nonatomic,strong)NSString *lock_no;
@property (nonatomic,strong)NSString *realName;
@property (nonatomic,strong)NSString *reason;
@property (nonatomic,assign)NSInteger roomId;
@property (nonatomic,strong)NSString *room_name;
@property (nonatomic,strong)NSString *startTime;
@property (nonatomic,strong)NSString *tel;
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,assign)NSInteger type;
@property (nonatomic,strong)NSString *imageOrder;
@property (nonatomic,assign)NSInteger openType;  /*1.app开门  2.密码开门 */
@property (nonatomic,assign)NSInteger workType;  /*1.未流转  2.全部*/
@property (nonatomic,strong)NSString *roomName;
@property (nonatomic,strong)NSString *workOrder;
@property (nonatomic,strong)NSString *workerName;
@property (nonatomic,strong)NSString *workerReason;
@property (nonatomic,strong)NSString *workerTel;
@property (nonatomic,assign)NSInteger state;
@property (nonatomic,assign)NSInteger marketState;



@end
