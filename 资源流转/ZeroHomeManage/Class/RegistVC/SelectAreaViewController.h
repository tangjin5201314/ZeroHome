//
//  SelectAreaViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/4/26.
//  Copyright © 2017年 TW. All rights reserved.
//


#import "BaseViewController.h"

@interface SelectAreaViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (strong, nonatomic)  UISearchBar *search;
@property (weak, nonatomic) IBOutlet UITableView *searchArea;
@property (weak, nonatomic) IBOutlet UIButton *Area;
@property (weak, nonatomic) IBOutlet UIButton *skip;
//是否是修改、编辑小区
@property(nonatomic,assign)BOOL isEdit;
//是否是完善资料
@property(nonatomic,assign)BOOL isPerfectData;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *iPhoneNumber;
@end
