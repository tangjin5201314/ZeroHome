//
//  CustPickerView.h
//  ZeroHome
//
//  Created by TW on 16/11/30.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MotoRoomSelect)(NSString *selectRoom,NSInteger selecRow);

@interface CustPickerView : UIView
- (instancetype)initWithFrame:(CGRect)frame AndDataSouce:(NSArray *)soucerArray;

- (void)didFinishSelectedDate:(MotoRoomSelect)selectMotoRoom;
@end
