//
//  MyCenterViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface MyCenterViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic)  UIImageView *sexImage;
@property (strong, nonatomic)  UIButton *LoginRsg;
@property (strong, nonatomic)  UILabel *nickName;
@property (strong, nonatomic) UILabel *integral_lbl;
@property (nonatomic,strong)UILabel *conponLevel;
//@property (weak, nonatomic) IBOutlet UILabel *youhui;

@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)UITableView *CenterTabelView;
@end
