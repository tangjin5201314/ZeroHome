//
//  GWMenuItemCell.m
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/22.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import "GWMenuItemCell.h"
#import "MenuItemModel.h"

#define CellSizeHeight 60
#define CellSizeWidth 60

@implementation GWMenuItemCell

- (void)setContent:(id)model IndexPath:(NSIndexPath *)indexPath tbv:(UITableView *)tbv obj:(id)obj
{
    MenuItemModel *itemModel = (MenuItemModel *)model;
    if (_imvPosterImage == nil) {
        _imvPosterImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, CellSizeWidth, CellSizeHeight)];
//        _imvPosterImage.layer.borderColor = RGB_B(204, 204, 204).CGColor;
        
        _imvPosterImage.layer.borderWidth = 1;
        [self.contentView addSubview:_imvPosterImage];
    }
    _imvPosterImage.image = itemModel.posterImage;
    
    if (_lblGroupName == nil) {
        
        _lblGroupName = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_imvPosterImage.frame) + CGRectGetWidth(_imvPosterImage.frame) + 20, CGRectGetMinY(_imvPosterImage.frame) + 10,CGRectGetWidth(self.frame) - (CGRectGetMinX(_imvPosterImage.frame) + CGRectGetWidth(_imvPosterImage.frame) + 20), CellSizeHeight / 2)];
        _lblGroupName.font = FONT_SYSTEM(15.0);
        _lblGroupName.textColor = [UIColor blackColor];
        [self.contentView addSubview:_lblGroupName];
    }
    _lblGroupName.text = itemModel.groupName;
    
    if (_lblNumberOfAssets == nil) {
        _lblNumberOfAssets = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lblGroupName.frame), CGRectGetMinY(_lblGroupName.frame) + CGRectGetWidth(_lblGroupName.frame), CGRectGetWidth(_lblGroupName.frame), CGRectGetHeight(_lblGroupName.frame))];
        _lblNumberOfAssets.font = FONT_SYSTEM(12.0);
        _lblNumberOfAssets.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lblNumberOfAssets];
    }
    
    _lblNumberOfAssets.text = [NSString stringWithFormat:@"%ld张",(long)itemModel.numberOfAssets];
}

@end
