//
//  MotoRoomModel.h
//  ZeroHome
//
//  Created by TW on 16/12/2.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MotoRoomModel : NSObject

/*门锁编号*/
@property (nonatomic,strong)NSString *room_name;
@property (nonatomic,strong)NSString *lock_no;
@property (nonatomic,assign)NSInteger ID;
@property (nonatomic,assign)BOOL selected;
@end
