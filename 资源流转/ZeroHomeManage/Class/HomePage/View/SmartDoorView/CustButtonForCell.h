//
//  CustButtonForCell.h
//  ZeroHome
//
//  Created by TW on 16/1/30.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "convenceBtn.h"

@protocol selectButtonDelegat <NSObject>

- (void)selectBtnTag:(NSInteger)tag;

@end

@interface CustButtonForCell : UIView
@property (nonatomic,strong)convenceBtn *btn;

@property(nonatomic,weak)id<selectButtonDelegat>delegate;
@end
