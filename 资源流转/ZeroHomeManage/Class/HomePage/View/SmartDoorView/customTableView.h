//
//  customTableView.h
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@protocol MYTableViewDelegate <NSObject>

-(void)refHeadView:(MJRefreshHeaderView *)headView;
-(void)refFootView:(MJRefreshFooterView *)footView;
@end

@interface customTableView : UITableView<MJRefreshBaseViewDelegate>
@property(nonatomic,assign)BOOL headRefresh;
@property(nonatomic,assign)BOOL footRefresh;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)id<MYTableViewDelegate>RefreshDelegate;
-(instancetype)initWithCustomFrame:(CGRect)Frame Style:(UITableViewStyle)style myself:(id)myself;
-(void)Todealloc;

@property(nonatomic,strong)MJRefreshHeaderView *headView;
@property(nonatomic,strong)MJRefreshFooterView *footView;
@end
