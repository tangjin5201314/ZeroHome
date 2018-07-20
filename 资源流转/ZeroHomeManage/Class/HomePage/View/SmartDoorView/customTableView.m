//
//  customTableView.m
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//
#import "customTableView.h"

@implementation customTableView{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)Todealloc{
    [_headView free];
    [_footView free];
}
-(instancetype)initWithCustomFrame:(CGRect)Frame Style:(UITableViewStyle)style myself:(id)myself{
    self = [super initWithFrame:Frame style:style];
    if(self){
        self.frame = Frame;
        self.delegate = myself;
        self.dataSource = myself;
        self.backgroundColor = [UIColor colorWithRed:0.93f green:0.93f blue:0.94f alpha:1.00f];
        _dataArray = [[NSMutableArray alloc]init];
        //[self  setSeparatorInset:UIEdgeInsetsZero];
        //UIEdgeInsetsMake(0, -20, 0, 0)
        //self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //self.separatorStyle = UITableViewCellAccessoryNone;

    }
    return self;
}
-(void)setHeadRefresh:(BOOL)headRefresh{
    if(headRefresh){
        _headView = [[MJRefreshHeaderView alloc]initWithScrollView:self];
        _headView.delegate  =self;
    }
}
-(void)setFootRefresh:(BOOL)footRefresh{
    if(footRefresh){
        _footView = [[MJRefreshFooterView alloc]initWithScrollView:self];
        _footView.delegate = self;
    }
}
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if(refreshView == _headView){
        [_RefreshDelegate refHeadView:_headView];
    }
    if(refreshView == _footView){
        [_RefreshDelegate refFootView:_footView];
    }
}
@end
