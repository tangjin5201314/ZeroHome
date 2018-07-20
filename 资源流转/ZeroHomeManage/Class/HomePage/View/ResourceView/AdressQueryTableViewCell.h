//
//  AdressQueryTableViewCell.h
//  ZeroHomeManage
//
//  Created by 汤锦 on 2018/5/24.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AdressQueryCellDelegate<NSObject>
- (void)textFieldEditChangeWithText:(NSString *)address;
@end

@interface AdressQueryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *adress_texfield;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (nonatomic,weak)id<AdressQueryCellDelegate>delegage;
@end
