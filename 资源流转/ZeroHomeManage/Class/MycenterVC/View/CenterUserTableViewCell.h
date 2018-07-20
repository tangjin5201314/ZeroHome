//
//  CenterUserTableViewCell.h
//  ZeroHome
//
//  Created by 汤锦 on 2017/5/2.
//  Copyright © 2017年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CenterUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RightLabel;
@property (weak, nonatomic) IBOutlet UILabel *LeftLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightJianTou;

@property (nonatomic,strong)UIView *seperatView;
-(void)setImage:(NSString *)imageURL;
@end
