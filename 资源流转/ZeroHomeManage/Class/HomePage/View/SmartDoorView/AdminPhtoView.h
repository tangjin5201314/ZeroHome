//
//  AdminPhtoView.h
//  ZeroHome
//
//  Created by TW on 16/12/29.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol sharePhotoViewDelegate <NSObject>

-(void)zoomClick:(int)index;
- (void)clickImage;

@end
@interface AdminPhtoView : UIView

@property(nonatomic,weak)id<sharePhotoViewDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *photoNamesArray;

@property(nonatomic,assign)int type;

@property (nonatomic, assign) NSInteger maxItemsCount;
- (instancetype)initWithMaxItemsCount:(NSInteger)count;
@end
