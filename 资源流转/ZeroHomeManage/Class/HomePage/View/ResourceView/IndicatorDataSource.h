//
//  IndicatorDataSource.h
//  ZeroHomeManage
//
//  Created by TW on 2018/3/23.
//  Copyright © 2018年 TW. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IndicatorDataSource : NSObject<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray *dataArray;
@end
