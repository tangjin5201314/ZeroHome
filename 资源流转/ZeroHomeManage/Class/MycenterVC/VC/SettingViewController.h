//
//  SettingViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface SettingViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *SettableView;
@property(nonatomic,strong)NSArray *dataArray;
@end
