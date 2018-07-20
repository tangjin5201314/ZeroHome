//
//  commitPhoto.h
//  ZeroHome
//
//  Created by TW on 16/3/13.
//  Copyright © 2016年 TW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TZImagePickerController.h"

@interface commitPhoto : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,strong)UICollectionView *collection;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)id object;

-(instancetype)initWith:(id)object;
@end
