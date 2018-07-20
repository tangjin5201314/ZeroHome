//
//  AuthorizdTimeTableViewCell.h
//  ZeroHome
//
//  Created by TW on 16/11/29.
//  Copyright © 2016年 deguang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorizdTimeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *startData_field;
@property (weak, nonatomic) IBOutlet UITextField *startTime_field;
@property (weak, nonatomic) IBOutlet UITextField *endData_field;
@property (weak, nonatomic) IBOutlet UITextField *endTime_field;

@property (weak, nonatomic) IBOutlet UITextField *reason_field;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *divid_line;


@end
