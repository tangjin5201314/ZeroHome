//
//  SelectAreaCell.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/22.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectAreaCellDelegat <NSObject>
- (void)selectAreaBtnTag:(NSInteger)tag;

@end


@interface SelectAreaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *selectArea_fiedl;
@property (weak, nonatomic) IBOutlet UIButton *selectRoomBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@property (weak, nonatomic) IBOutlet UIButton *selectAreaBtn;
@property (nonatomic,weak)id<SelectAreaCellDelegat>delegate;
@end
