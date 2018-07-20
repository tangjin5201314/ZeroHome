//
//  HomePageViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"
#import "homePageBtn.h"


@interface HomePageViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong)NSMutableArray *imgs;
@property (strong, nonatomic) homePageBtn *titleBtn;
@property (strong, nonatomic) UIButton *rightBarItme;
@property(nonatomic,strong)UITableView *maintableView;

@property (nonatomic,strong)NSString *roomName;
@property (nonatomic,strong)NSString *roomLock_no;
@property (nonatomic,assign)NSNumber* roomId;



@end
