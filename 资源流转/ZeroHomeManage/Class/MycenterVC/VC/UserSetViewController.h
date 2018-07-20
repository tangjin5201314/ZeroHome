//
//  UserSetViewController.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import "BaseViewController.h"

@interface UserSetViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *CenterTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;


@property(nonatomic,strong)NSString *imageURL;
@end
