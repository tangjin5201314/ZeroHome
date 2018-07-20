//
//  SelectRoomViewController.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@protocol SelectRoomViewDelegate <NSObject>
-(void)callBackRoomInfomationWithDic:(NSDictionary *)dic;
@end

typedef void (^CallBackSelectLockInfo)(NSString * LockroomName,NSString *LockroomId);
@interface SelectRoomViewController : BaseViewController
@property (nonatomic,weak)id<SelectRoomViewDelegate>delegate;
@property (nonatomic,copy)CallBackSelectLockInfo block;

//@property (nonatomic,strong)NSDictionary *provinceDic;
@property (nonatomic,strong)NSString *province;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *area;
@property (nonatomic,assign,getter=isSelectProvince)BOOL selectProvince;
@end
