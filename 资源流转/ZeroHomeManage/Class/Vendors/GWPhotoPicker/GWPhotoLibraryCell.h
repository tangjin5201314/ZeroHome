//
//  GWPhotoLibraryCell.h
//  GWTestProj
//
//  Created by Tentinet2015 on 15/3/22.
//  Copyright (c) 2015年 wanggw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GWPhotoLibraryCell : UICollectionViewCell
{
    UIImageView *_imvTick;
    UIImageView *_imvPhoto;
    UIView *_vBgCover;
}

- (void)setContent:(id)model
         IndexPath:(NSIndexPath *)indexPath
    CollectionView:(UICollectionView *)collectionView
               obj:(id)obj;

@end
