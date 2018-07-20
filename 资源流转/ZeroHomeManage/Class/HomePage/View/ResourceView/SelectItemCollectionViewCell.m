//
//  SelectItemCollectionViewCell.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "SelectItemCollectionViewCell.h"

@implementation SelectItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RoomPortModel *)model
{
    switch (model.portType) {
        case 1:
        {
            self.operatorName_lbl.text = @"电";
            self.backView.backgroundColor = [UIColor yellowColor];
        }
            break;
         case 2:
        {
            self.operatorName_lbl.text = @"移";
            self.backView.backgroundColor = [UIColor yellowColor];
        }
            break;
        case 3:
        {
            self.operatorName_lbl.text = @"联";
            self.backView.backgroundColor = [UIColor yellowColor];
        }
            break;
            case 4:
        {
            self.operatorName_lbl.text = @"长";
            self.backView.backgroundColor = [UIColor yellowColor];
        }
            break;
            case 5:
        {
            self.operatorName_lbl.text = @"通";
            self.backView.backgroundColor = [UIColor yellowColor];
        }
            break;
            case 6:
            self.operatorName_lbl.text = @"备";
            self.backView.backgroundColor = [UIColor whiteColor];
            break;
            case 7:
            self.operatorName_lbl.text = @"无";
            self.backView.backgroundColor = [UIColor whiteColor];
            break;
        default:
            break;
    }

}

@end
