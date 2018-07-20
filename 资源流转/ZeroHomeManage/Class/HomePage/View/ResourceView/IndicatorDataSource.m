//
//  IndicatorDataSource.m
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import "IndicatorDataSource.h"
#import "IndicatorCollectionViewCell.h"

@implementation IndicatorDataSource
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section

{
    return UIEdgeInsetsMake(1, 0, 0, 0);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(24, 40);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IndicatorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IndicatorCollectionViewCell" forIndexPath:indexPath];
    cell.row.text = [NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]];
    return cell;
}
@end
