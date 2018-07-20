//
//  CapacityUnlockController.h
//  ZeroHome
//
//  Created by TW on 16/12/28.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

typedef NS_ENUM(NSInteger, NSKPeopleInFomation) {
    NSKTongWang,
    NSKYunying,
    NSKAdmin
};
typedef void (^CallBackInfoLock)(NSString * CapaCityroomName,NSString *CapaCityroomLock_no,NSNumber *CapaCityroomId);
@interface CapacityUnlockController : BaseViewController
@property (nonatomic,assign)NSKPeopleInFomation peopleInfomation;
@property (strong, nonatomic) IBOutlet UIScrollView *my_ScrollView;
@property (strong, nonatomic) IBOutlet UIView *my_View;
@property (weak, nonatomic) IBOutlet UIScrollView *backScrollView;

@property (weak, nonatomic) IBOutlet UIView *phto_view;
@property (weak, nonatomic) IBOutlet UIView *mtorRoom_view;
@property (weak, nonatomic) IBOutlet UIView *authenTime_view;
@property (weak, nonatomic) IBOutlet UIView *bottom_view;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *diliviView;

@property (nonatomic,strong)NSMutableArray *roomArray;
@property (nonatomic,copy)CallBackInfoLock callBackLockBlock;
@end
