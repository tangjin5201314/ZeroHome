//
//  GWPhotoLibraryCell.m
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/22.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import "GWPhotoLibraryCell.h"
#import "ALAssetModel.h"

@implementation GWPhotoLibraryCell

- (void)setContent:(id)model
         IndexPath:(NSIndexPath *)indexPath
    CollectionView:(UICollectionView *)collectionView
               obj:(id)obj
{
    ALAssetModel *assetModel = (ALAssetModel *)model;
    if (_imvPhoto == nil) {
        _imvPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameSizeWidth, self.contentView.frameSizeHeight)];
        _imvPhoto.userInteractionEnabled = NO;
        [self.contentView addSubview:_imvPhoto];
    }

    _imvPhoto.image = assetModel.image;

    if (_imvTick == nil) {
        if (assetModel.tickImgName != nil) {
            UIImage *tick  = [UIImage imageNamed:assetModel.tickImgName];
            _imvTick = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(_imvPhoto.frame) - 5 - tick.size.width, 5,tick.size.width, tick.size.height)];
            _imvTick.image = tick;
            _imvTick.userInteractionEnabled = NO;
            [self.contentView addSubview:_imvTick];
        }
    }
    if (_vBgCover == nil) {
        _vBgCover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frameSizeWidth, self.contentView.frameSizeHeight)];
        _vBgCover.backgroundColor = [UIColor blackColor];
        _vBgCover.alpha = 0.4;
        _vBgCover.hidden = YES;
        _vBgCover.userInteractionEnabled = NO;
        [self.contentView addSubview:_vBgCover];
    }
    if (assetModel.selected) {
        _vBgCover.hidden = NO;
        _imvTick.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_selected",assetModel.tickImgName]];
    }else{
        _vBgCover.hidden = YES;
        _imvTick.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",assetModel.tickImgName]];
    }
}

@end
